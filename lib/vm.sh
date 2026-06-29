#!/usr/bin/env bash
# vm.sh — Incus VM lifecycle helpers (cert-agnostic)
#
# Callers set:  VM_NAMES  (array of all VM names for this session)
# topology.sh provides: topology_create, topology_destroy

# ── existence / state ─────────────────────────────────────────────────────────
vm_exists() {
  local name="$1"
  incus info "$name" &>/dev/null
}

vm_running() {
  local name="$1"
  [[ "$(incus info "$name" 2>/dev/null | awk '/^Status:/{print tolower($2)}')" == "running" ]]
}

# ── lifecycle ─────────────────────────────────────────────────────────────────
vm_start() {
  local name="$1"
  vm_running "$name" && return 0
  incus start "$name"
  vm_wait_ready "$name"
}

vm_stop() {
  local name="$1"
  vm_running "$name" || return 0
  incus stop "$name" --force
}

vm_delete() {
  local name="$1"
  vm_exists "$name" || return 0
  incus delete "$name" --force
}

# Poll until the Incus agent responds inside the VM, then until a default route
# exists (proxy for NetworkManager having finished). The agent comes up via the
# bootstrap service (After=sysinit.target), which runs before NetworkManager
# finishes — without the second poll, dnf/curl in setup scripts race against NM.
vm_wait_ready() {
  local name="$1"
  local max_attempts=300   # 300 × 2 s = 10 min
  local attempt=0
  info "Waiting for VM agent: $name"
  while ! incus exec "$name" -- true </dev/null &>/dev/null; do
    echo -n "."
    sleep 2
    (( attempt++ )) || true
    if [[ $attempt -ge $max_attempts ]]; then
      echo ""
      warn "If this is a fresh VM, cloud-init may still be running."
      warn "Check: incus console $name"
      die "VM agent timeout: $name"
    fi
  done
  echo ""

  # Wait for a default route — confirms NetworkManager has configured the NIC.
  attempt=0
  while ! incus exec "$name" -- bash -c \
      'ip route show default 2>/dev/null | grep -q default' </dev/null &>/dev/null; do
    echo -n "~"
    sleep 2
    (( attempt++ )) || true
    if [[ $attempt -ge 60 ]]; then   # 60 × 2 s = 2 min max
      echo ""
      warn "No default route in VM $name — network may be misconfigured"
      break
    fi
  done
  if (( attempt > 0 )); then echo ""; fi

  # Wait for SFTP to be ready — the incus agent initialises the SFTP subsystem
  # slightly after the exec socket.  File pushes fail with HTTP-500 if we
  # proceed before this is up.
  attempt=0
  while ! incus file pull "${name}/etc/hostname" /dev/null &>/dev/null; do
    sleep 1
    (( attempt++ )) || true
    [[ $attempt -ge 30 ]] && break   # 30 s max — don't block indefinitely
  done
}

# ── exec helpers ──────────────────────────────────────────────────────────────

# Push a local script to the VM via incus file push, execute it, then remove it.
# This avoids stdin-pipe issues in scripts that read from stdin themselves
# (e.g. passwd, fdisk). The script runs as root.
# Retries up to 3 times if the VM agent drops the vsock connection mid-exec.
vm_exec_script() {
  local name="$1"
  local script="$2"
  [[ -f "$script" ]] || die "Script not found: $script"

  local remote="/tmp/rhtr-$$.sh"
  local rc=0
  local attempt

  for attempt in 1 2 3; do
    # File push uses SFTP, which the incus agent initialises slightly after the
    # exec socket.  Retry the push on failure (e.g. HTTP-500 on first launch)
    # rather than letting set -e abort the whole session setup.
    if ! incus file push --mode 0700 "$script" "${name}${remote}" 2>/dev/null; then
      [[ $attempt -lt 3 ]] || { warn "File push failed after 3 attempts: $script"; return 1; }
      warn "SFTP push failed (attempt $attempt/3) — waiting 5 s for agent SFTP..."
      sleep 5
      continue
    fi
    rc=0
    # </dev/null prevents incus exec from consuming the caller's stdin (e.g. a
    # while-loop file descriptor), which would swallow remaining loop iterations.
    incus exec "$name" -- bash "$remote" </dev/null || rc=$?
    incus exec "$name" -- rm -f "$remote" </dev/null &>/dev/null || true
    [[ $rc -eq 0 ]] && return 0
    # If the agent still responds, the script itself failed — don't retry.
    incus exec "$name" -- true </dev/null &>/dev/null && return $rc
    [[ $attempt -lt 3 ]] || break
    warn "VM agent lost during exec (attempt $attempt/3) — reconnecting..."
    vm_wait_ready "$name"
  done
  return $rc
}

# Run an arbitrary command inside a VM as root
vm_exec() {
  local name="$1"
  shift
  incus exec "$name" -- "$@"
}

# Open an interactive shell in a VM
vm_shell() {
  local name="$1"
  incus shell "$name"
}

# ── snapshots ─────────────────────────────────────────────────────────────────
SNAPSHOT_NAME="pre-exam"

# Create (or atomically replace) the pre-exam snapshot using --reuse.
# --reuse avoids the delete-then-create window where no snapshot exists.
vm_snapshot_create() {
  local name="$1"
  incus snapshot create "$name" "$SNAPSHOT_NAME" --reuse
}

vm_snapshot_restore() {
  local name="$1"
  incus snapshot restore "$name" "$SNAPSHOT_NAME"
  vm_wait_ready "$name"
}

# ── profiles ──────────────────────────────────────────────────────────────────

# Ensure an Incus profile exists and has the given key=value config entries.
# Idempotent: safe to call on every topology_create.
#
# Usage: vm_profile_ensure <profile-name> key=val [key=val ...]
vm_profile_ensure() {
  local profile="$1"; shift

  if ! incus profile show "$profile" &>/dev/null; then
    info "Creating Incus profile: $profile"
    incus profile create "$profile"
  fi

  for kv in "$@"; do
    incus profile set "$profile" "$kv"
  done
}

# ── image guard ───────────────────────────────────────────────────────────────

# Abort with a helpful message if the required Incus image alias is missing
vm_require_image() {
  local alias="$1"
  if ! incus image list --format csv | cut -d',' -f1 | grep -qx "$alias"; then
    local version="${alias#rocky}"
    die "Incus image '$alias' not found.

Download it first:
  wget https://download.rockylinux.org/pub/rocky/${version}/images/x86_64/Rocky-${version}-GenericCloud-Base.latest.x86_64.qcow2

Then import it:
  rhtr import-image ${alias} Rocky-${version}-GenericCloud-Base.latest.x86_64.qcow2"
  fi
}

# Import a Rocky QCOW2 as an Incus VM image, creating the required metadata tarball.
# Usage: vm_import_image <alias> <path-to-qcow2>
vm_import_image() {
  local alias="${1:-}"
  local qcow2="${2:-}"

  if [[ -z "$alias" || -z "$qcow2" ]]; then
    die "Usage: rhtr import-image <alias> <path-to-qcow2>
Example: rhtr import-image rocky10 Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
  fi

  local version="${alias#rocky}"

  [[ -f "$qcow2" ]] || die "QCOW2 not found: $qcow2"

  local tmpdir
  tmpdir="$(mktemp -d)"
  trap "rm -rf '$tmpdir'" EXIT

  cat > "$tmpdir/metadata.yaml" <<EOF
architecture: x86_64
creation_date: $(date +%s)
properties:
  description: Rocky Linux ${version} GenericCloud
  os: rocky
  release: "${version}"
  type: virtual-machine
templates: {}
EOF

  tar czf "$tmpdir/metadata.tar.gz" -C "$tmpdir" metadata.yaml

  info "Importing '$alias' from $(basename "$qcow2") ..."
  incus image import "$tmpdir/metadata.tar.gz" "$qcow2" --alias "$alias"
  info "Image '$alias' imported."

  # Inject the incus-agent bootstrap service so VMs boot with a working agent.
  # Incus silently ignores cloud-init.vendor-data for VMs; the bootstrap must
  # live inside the image itself. It mounts the agent CD-ROM (/dev/disk/by-label/
  # incus-agent) on first boot and runs install.sh, then self-disables via
  # ConditionPathExists=!/usr/lib/systemd/system/incus-agent.service.
  # ExecStart uses /bin/bash to avoid SELinux blocking unlabeled_t file exec.
  info "Injecting incus-agent bootstrap into '$alias' image ..."
  _vm_inject_agent_bootstrap "$alias"
  info "Bootstrap injected."
}

# Patch the rootfs of an already-imported Incus VM image to include the
# incus-agent bootstrap service. Uses qemu-nbd; requires root (sudo).
_vm_inject_agent_bootstrap() {
  local alias="$1"
  local fingerprint
  fingerprint=$(incus image list --format csv | awk -F',' -v a="$alias" '$1==a{print $2}')
  [[ -n "$fingerprint" ]] || die "Image '$alias' not found in Incus image store."

  local rootfs="/var/lib/incus/images/${fingerprint}.rootfs"
  [[ -f "$rootfs" ]] || die "Rootfs not found: $rootfs"

  local mnt
  mnt="$(mktemp -d)"
  local nbd_dev="/dev/nbd0"

  sudo modprobe nbd max_part=8 2>/dev/null || true
  sudo qemu-nbd --connect="$nbd_dev" "$rootfs"

  local root_part
  root_part=$(sudo fdisk -l "$nbd_dev" 2>/dev/null \
    | awk '/Linux root/{print $1}' | head -1)
  [[ -n "$root_part" ]] || root_part="${nbd_dev}p4"

  sudo mount "$root_part" "$mnt"

  sudo mkdir -p "$mnt/usr/local/libexec"
  sudo mkdir -p "$mnt/etc/systemd/system/multi-user.target.wants"

  sudo tee "$mnt/usr/local/libexec/incus-agent-bootstrap.sh" > /dev/null << 'SCRIPT'
#!/bin/bash
set -ex
mkdir -p /run/incus-agent-install
mount /dev/disk/by-label/incus-agent /run/incus-agent-install
cd /run/incus-agent-install
bash install.sh
cd /
umount /run/incus-agent-install
rmdir /run/incus-agent-install
systemctl daemon-reload
systemctl start incus-agent.service
SCRIPT

  sudo tee "$mnt/usr/lib/systemd/system/incus-agent-bootstrap.service" > /dev/null << 'UNIT'
[Unit]
Description=Incus Agent Bootstrap (first boot only)
ConditionPathExists=!/usr/lib/systemd/system/incus-agent.service
After=sysinit.target
Wants=sysinit.target

[Service]
Type=oneshot
RemainAfterExit=yes
StandardOutput=kmsg
StandardError=kmsg
ExecStart=/bin/bash /usr/local/libexec/incus-agent-bootstrap.sh

[Install]
WantedBy=multi-user.target
UNIT

  sudo ln -sf /usr/lib/systemd/system/incus-agent-bootstrap.service \
    "$mnt/etc/systemd/system/multi-user.target.wants/incus-agent-bootstrap.service"

  sudo umount "$mnt"
  rmdir "$mnt"
  sudo qemu-nbd --disconnect "$nbd_dev"
}
