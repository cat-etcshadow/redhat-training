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
  # Setup scripts (passwd, dnf, podman pull, etc.) are noisy on stdout/stderr.
  # Capture it and only surface it when the script actually fails, so a clean
  # run shows just the task progress line.
  local out; out=$(mktemp)

  for attempt in 1 2 3; do
    # File push uses SFTP, which the incus agent initialises slightly after the
    # exec socket.  Retry the push on failure (e.g. HTTP-500 on first launch)
    # rather than letting set -e abort the whole session setup.
    if ! incus file push --mode 0700 "$script" "${name}${remote}" 2>/dev/null; then
      [[ $attempt -lt 3 ]] || { warn "File push failed after 3 attempts: $script"; rm -f "$out"; return 1; }
      warn "SFTP push failed (attempt $attempt/3) — waiting 5 s for agent SFTP..."
      sleep 5
      continue
    fi
    rc=0
    # </dev/null prevents incus exec from consuming the caller's stdin (e.g. a
    # while-loop file descriptor), which would swallow remaining loop iterations.
    # setsid -w detaches the script (and any `cmd &` it backgrounds) from this
    # exec's session — without it, a task's backgrounded child (e.g. a test
    # HTTP server) stays tied to the exec channel and the whole call hangs
    # forever after the script itself has finished. -w makes setsid wait and
    # forward the real exit code even on the internal-fork fallback path.
    incus exec "$name" -- setsid -w bash "$remote" </dev/null &>"$out" || rc=$?
    incus exec "$name" -- rm -f "$remote" </dev/null &>/dev/null || true
    if [[ $rc -eq 0 ]]; then
      rm -f "$out"
      return 0
    fi
    # If the agent still responds, the script itself failed — don't retry.
    if incus exec "$name" -- true </dev/null &>/dev/null; then
      warn "Setup script failed (rc=$rc): $script"
      cat "$out" >&2
      rm -f "$out"
      return $rc
    fi
    [[ $attempt -lt 3 ]] || break
    warn "VM agent lost during exec (attempt $attempt/3) — reconnecting..."
    vm_wait_ready "$name"
  done
  cat "$out" >&2
  rm -f "$out"
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

# Attach to the VM's raw serial console — unlike vm_shell/incus exec, this
# works without the incus-agent, so it's the only way in at the GRUB menu,
# in rd.break, or in emergency/rescue mode.
vm_console() {
  local name="$1"
  info "Attaching to console of $name — Ctrl+a q to detach"
  incus console "$name"
}

# ── snapshots ─────────────────────────────────────────────────────────────────
SNAPSHOT_NAME="pre-exam"

# Create (or atomically replace) the pre-exam snapshot using --reuse.
# --reuse avoids the delete-then-create window where no snapshot exists.
#
# Right after `incus launch`, Incus can still consider the instance's
# "create" operation in-flight even though the guest agent already answers
# (vm_wait_ready passed) — a snapshot attempt in that window fails with
# "Instance is busy running a \"create\" operation". Retry through it.
vm_snapshot_create() {
  local name="$1"
  local attempt
  for attempt in 1 2 3 4 5; do
    incus snapshot create "$name" "$SNAPSHOT_NAME" --reuse && return 0
    [[ $attempt -lt 5 ]] || return 1
    sleep 2
  done
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

  # RHEL-family kernels (8/9/10 and derivatives, including Rocky) ship no 9p
  # driver at all, so Incus's default 9p-based agent config share can never
  # mount — see vm_ensure_agent_config_drive for the full story. Adding the
  # device to the profile (rather than the instance, post-launch) matters:
  # Incus only attaches `source=agent:config` correctly when it's present
  # *before* the VM's first start — adding it to an already-running instance
  # is a silent no-op until the next full stop/start cycle. Putting it on
  # the profile guarantees it's there from `incus launch` on.
  incus profile device show "$profile" 2>/dev/null | grep -q '^agent-config:' \
    || incus profile device add "$profile" agent-config disk source=agent:config
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
  # `incus image list` truncates fingerprints to 12 chars — the on-disk
  # rootfs is named after the full SHA256, so a truncated name never matches
  # any real file. `incus image info` prints the untruncated fingerprint.
  fingerprint=$(incus image info "$alias" 2>/dev/null | awk '/^Fingerprint:/{print $2}')
  [[ -n "$fingerprint" ]] || die "Image '$alias' not found in Incus image store."

  local rootfs="/var/lib/incus/images/${fingerprint}.rootfs"
  # /var/lib/incus/images is root-only (0700) — a plain `[[ -f ]]` as a
  # non-root user always reports "not found" (permission denied on the
  # parent dir), regardless of whether the file is actually there.
  sudo test -f "$rootfs" || die "Rootfs not found: $rootfs"

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

  # Install the *real* incus-agent unit, setup script, and udev rule — the
  # same three files Incus writes into every VM's per-instance config drive
  # at .../<instance>/config/{systemd,udev}/. Those files' own install.sh
  # says outright: "This script must be run from within the 9p mount" — the
  # agent config drive is a 9p share (tag "config"), not a block device, so
  # an earlier version of this function that did
  # `mount /dev/disk/by-label/incus-agent ...` could never find anything to
  # mount. Writing these three static files directly into the rootfs here
  # reproduces exactly what a distrobuilder-built VM image ships out of the
  # box: a udev rule fires when the virtio-serial port
  # (virtio-ports/org.linuxcontainers.incus) appears, which tags the device
  # with SYSTEMD_WANTS=incus-agent.service; that service's ExecStartPre
  # mounts the 9p config share, copies the agent binary out of it into
  # /run/incus_agent, then the main ExecStart launches it.
  #
  # The unit also carries [Install] WantedBy=multi-user.target and is
  # symlinked into multi-user.target.wants/ below (like sshd.service), on
  # top of the udev trigger. The udev SYSTEMD_WANTS only fires once, when
  # the virtio-serial device first appears at boot — an RHCSA task that
  # does `systemctl isolate rescue.target` (which stops the agent, since
  # rescue.target doesn't want it) and then `systemctl isolate
  # multi-user.target` never re-triggers that udev event, so without the
  # Install section the agent stayed dead for the rest of the session and
  # took every subsequent grade.sh down with it (see ch11-boot/isolate-target-v1).
  # WantedBy=multi-user.target makes `systemctl isolate` restart it exactly
  # like any other properly enabled service.
  sudo mkdir -p "$mnt/usr/lib/udev/rules.d"
  sudo mkdir -p "$mnt/usr/lib/systemd/system/multi-user.target.wants"

  sudo tee "$mnt/usr/lib/udev/rules.d/99-incus-agent.rules" > /dev/null << 'RULES'
SYMLINK=="virtio-ports/org.linuxcontainers.incus", TAG+="systemd", ENV{SYSTEMD_WANTS}+="incus-agent.service"
RULES

  # ExecStartPre path below is TARGET/systemd/incus-agent-setup with
  # TARGET=/usr/lib — the same substitution install.sh performs when it
  # picks a writable prefix (it tries /usr/lib, /lib, /etc in that order).
  sudo tee "$mnt/usr/lib/systemd/system/incus-agent.service" > /dev/null << 'UNIT'
[Unit]
Description=Incus - agent
Documentation=https://linuxcontainers.org/incus/docs/main/
Before=multi-user.target cloud-init.target cloud-init.service cloud-init-local.service
DefaultDependencies=no

[Service]
Type=notify
WorkingDirectory=-/run/incus_agent
ExecStartPre=/usr/lib/systemd/incus-agent-setup
ExecStart=/run/incus_agent/incus-agent
Restart=on-failure
RestartSec=5s
StartLimitInterval=60
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
UNIT

  sudo ln -sf ../incus-agent.service \
    "$mnt/usr/lib/systemd/system/multi-user.target.wants/incus-agent.service"

  # Same as the stock incus-agent-setup, except the final relabel step uses
  # chcon instead of semanage fcontext + restorecon — see the chcon call
  # below for why.
  sudo tee "$mnt/usr/lib/systemd/incus-agent-setup" > /dev/null << 'SETUP'
#!/bin/sh
set -eu
PREFIX="/run/incus_agent"
CDROM="/dev/disk/by-label/incus-agent"

mount_cdrom() {
    mount "${CDROM}" "${PREFIX}.mnt" >/dev/null 2>&1
}

mount_9p() {
    modprobe 9pnet_virtio >/dev/null 2>&1 || true
    mount -t 9p config "${PREFIX}.mnt" -o access=0,trans=virtio,size=1048576 >/dev/null 2>&1
}

fail() {
    if [ -x "${PREFIX}/incus-agent" ]; then
        echo "${1}, reusing existing agent"
        exit 0
    fi

    umount -l "${PREFIX}" >/dev/null 2>&1 || true
    eject "${CDROM}" >/dev/null 2>&1 || true
    rmdir "${PREFIX}" >/dev/null 2>&1 || true
    echo "${1}, failing"

    exit 1
}

mkdir -p "${PREFIX}.mnt"
mount_9p || mount_cdrom || fail "Couldn't mount 9p or cdrom"

umount -l "${PREFIX}" >/dev/null 2>&1 || true
mkdir -p "${PREFIX}"
mount -t tmpfs tmpfs "${PREFIX}" -o mode=0700,size=50M

cp -Ra "${PREFIX}.mnt/"* "${PREFIX}"

umount "${PREFIX}.mnt"
rmdir "${PREFIX}.mnt"

eject "${CDROM}" >/dev/null 2>&1 || true

chown -R root:root "${PREFIX}"

if [ ! -e "${PREFIX}/incus-agent" ] && [ -e "${PREFIX}/lxd-agent" ]; then
    ln -s lxd-agent "${PREFIX}"/incus-agent
fi

# `cp -Ra` preserves the ISO source's SELinux context, so the copied binary
# lands as iso9660_t — init_t can't execute that, and incus-agent.service
# fails every boot. The stock fix (semanage fcontext + restorecon) hangs
# indefinitely this early in boot (confirmed: waited 3+ minutes, it never
# returned) — likely a policy-store lock or dependency not up yet.  chcon
# just rewrites the xattr in place, no policy-store write involved, and
# returns instantly.
chcon -t bin_t "${PREFIX}/incus-agent" >/dev/null 2>&1 || true

exit 0
SETUP

  sudo chmod 0644 "$mnt/usr/lib/udev/rules.d/99-incus-agent.rules" \
                  "$mnt/usr/lib/systemd/system/incus-agent.service"
  sudo chmod 0755 "$mnt/usr/lib/systemd/incus-agent-setup"

  # Files written through the nbd mount get their security.selinux xattr
  # from the *host* kernel's SELinux module, same as any other write(2).
  # When that module is live (`selinuxenabled`), plain `restorecon` labels
  # the new files correctly, same as it would for any other file the host
  # writes into a mounted filesystem.
  #
  # When the host kernel has no SELinux module loaded at all — WSL2,
  # Ubuntu, any non-RHEL host without SELinux enabled — the files land
  # completely unlabeled instead. The guest sees them as unlabeled_t;
  # init_t is not allowed to execute unlabeled_t, so incus-agent-setup's
  # ExecStartPre gets an AVC denial on first boot (confirmed via
  # `incus console --show-log`). `restorecon`/`chcon` can't fix this from
  # the host side either — both call libselinux's is_selinux_enabled(),
  # which checks the *host* kernel, and silently no-op when it's false.
  # `/.autorelabel` was tried and works, but it forces a guest-triggered
  # reboot to apply — and Incus only attaches the dynamically-generated
  # `agent:config` CD-ROM at VM starts *it* initiates, not at a reboot the
  # guest triggers internally, so the ISO (and the agent files on it) is
  # gone by the time the relabelled system comes back up. Confirmed via
  # `incus console --show-log`: first boot shows the CD-ROM and a working
  # mount, the post-relabel reboot shows an empty `/dev/disk/by-label/`.
  #
  # The fix that needs neither a live host SELinux kernel nor a guest
  # reboot: `setfattr` writes the `security.selinux` xattr as a plain
  # extended attribute — a generic filesystem operation the SELinux LSM
  # doesn't need to be active to perform. `matchpathcon`, run inside a
  # chroot of the guest's own rootfs, reads the guest's policy to compute
  # the context each path *should* have (it only computes — it doesn't
  # write, so unlike restorecon it doesn't care whether the host enforces
  # SELinux). Together they label the files correctly for the guest's own
  # policy without ever booting it.
  if selinuxenabled 2>/dev/null; then
    sudo restorecon -R \
      "$mnt/usr/lib/udev/rules.d/99-incus-agent.rules" \
      "$mnt/usr/lib/systemd/system/incus-agent.service" \
      "$mnt/usr/lib/systemd/system/multi-user.target.wants/incus-agent.service" \
      "$mnt/usr/lib/systemd/incus-agent-setup"
  else
    local path context
    for path in \
      /usr/lib/udev/rules.d/99-incus-agent.rules \
      /usr/lib/systemd/system/incus-agent.service \
      /usr/lib/systemd/system/multi-user.target.wants/incus-agent.service \
      /usr/lib/systemd/incus-agent-setup
    do
      # Full path required: sudo's secure_path strips /usr/sbin from the
      # chroot's PATH, and matchpathcon (policycoreutils) lives there.
      context=$(sudo chroot "$mnt" /usr/sbin/matchpathcon -n "$path" 2>/dev/null)
      [[ -n "$context" ]] || die "matchpathcon found no SELinux context for $path — agent would be unlabeled and fail to execute under enforcing SELinux"
      # -h: the .wants/ entry is a symlink — label the link itself, not the
      # unit file it points at (which was already labelled by its own loop
      # iteration).
      if [[ -L "$mnt$path" ]]; then
        sudo setfattr -h -n security.selinux -v "$context" "$mnt$path"
      else
        sudo setfattr -n security.selinux -v "$context" "$mnt$path"
      fi
    done
  fi

  sudo umount "$mnt"
  rmdir "$mnt"
  sudo qemu-nbd --disconnect "$nbd_dev"
}
