#!/usr/bin/env bash
# topology.sh — RHCSA VM environment
#
# Provides: topology_create, topology_destroy
# Reads:    RHEL_VERSION (set by exam.sh from --rhel flag or cert default)
#           EXTRA_DISK_SIZES_GIB (set by exam.sh's _assign_task_disks, one
#           entry per selected task that needs a dedicated disk — may be
#           empty)
#           SESSION_NEEDS_CONTAINERS (set by exam.sh's _assign_task_requirements;
#           "1" only when a ch16-containers task is in the selected session —
#           gates the podman install + offline registry mirror so profiles
#           like networking/storage/lvm don't pay for container setup)
#
# Environment:
#   1 VM:    rhtr-rhcsa-server-<version>  (Rocky Linux, SELinux enforcing)
#   N disks: rhtr-rhcsa-disk-<version>-1..N  (one block volume per disk-
#            needing task in the session, sized per EXTRA_DISK_SIZES_GIB —
#            see _assign_task_disks in lib/exam.sh for why each task gets
#            its own disk instead of sharing one)
#
# Incus profile "rhtr-rhcsa" is created once and reused across sessions.
# It captures all VM-level config so incus launch stays a one-liner.

_rhcsa_vm_name()      { echo "rhtr-rhcsa-server-${RHEL_VERSION}"; }
_rhcsa_disk_name()    { echo "rhtr-rhcsa-disk-${RHEL_VERSION}-${1}"; }
_rhcsa_image()        { echo "rocky${RHEL_VERSION}"; }
_rhcsa_profile_name() { echo "rhtr-rhcsa"; }

# VM_NAMES is read by exam.sh and report.sh to know which VMs to exec into
VM_NAMES=()

# Populate VM_NAMES without creating anything — used by session commands
# (shell, grade, reset) that need the names but not the full topology_create path.
# Requires RHEL_VERSION to be set (loaded from exam.conf).
topology_names() {
  VM_NAMES=("$(_rhcsa_vm_name)")
}

topology_create() {
  local vm;      vm=$(_rhcsa_vm_name)
  local img;     img=$(_rhcsa_image)
  local profile; profile=$(_rhcsa_profile_name)
  local -a sizes=("${EXTRA_DISK_SIZES_GIB[@]}")

  VM_NAMES=("$vm")

  vm_require_image "$img"

  # Ensure the shared profile exists with current settings (idempotent)
  vm_profile_ensure "$profile" \
    "security.secureboot=false" \
    "limits.cpu=2" \
    "limits.memory=2GiB"

  # Create block volumes before the VM so they're ready to attach immediately after launch.
  local i disk
  for i in "${!sizes[@]}"; do
    disk=$(_rhcsa_disk_name "$((i + 1))")
    if ! incus storage volume info default "$disk" &>/dev/null; then
      info "Creating block disk: $disk (${sizes[$i]} GiB)"
      incus storage volume create default "$disk" --type=block size="${sizes[$i]}GiB"
    fi
  done

  if vm_exists "$vm"; then
    info "VM $vm already exists — starting..."
    vm_start "$vm"
    # Re-attach any disk that was removed; run udevadm settle so the OS sees it.
    local attached settled=0
    attached=$(incus config device show "$vm")
    for i in "${!sizes[@]}"; do
      disk=$(_rhcsa_disk_name "$((i + 1))")
      if ! grep -q "^extradisk$((i + 1)):" <<<"$attached"; then
        incus config device add "$vm" "extradisk$((i + 1))" disk pool=default source="$disk"
        settled=1
      fi
    done
    [[ $settled -eq 1 ]] && vm_exec "$vm" udevadm settle

    # Idempotent — no-ops once already clean. Covers VMs created before this
    # cleanup existed.
    vm_exec_script "$vm" "$RHTR_DIR/certs/rhcsa/grub-cleanup.sh" \
      || warn "grub-cleanup.sh failed on $vm — ch11-boot tasks using --update-kernel=DEFAULT may be unreliable"

    vm_exec_script "$vm" "$RHTR_DIR/certs/rhcsa/grub-serial-console.sh" \
      || warn "grub-serial-console.sh failed on $vm — the GRUB menu may not be visible over 'rhtr rhcsa console'"

    vm_exec_script "$vm" "$RHTR_DIR/certs/rhcsa/root-unlock.sh" \
      || warn "root-unlock.sh failed on $vm — sulogin-gated rescue/emergency targets (isolate-target-v1, repair-fstab-v1) may be unreachable"

    # Only touch podman/the registry mirror when this session actually has a
    # container task — most profiles (networking, storage, lvm, ...) don't.
    if [[ "${SESSION_NEEDS_CONTAINERS:-0}" == "1" ]]; then
      # Retrofit the offline registry mirror onto VMs created before it existed.
      # No-op if already configured; best-effort if internet isn't available.
      vm_exec_script "$vm" "$RHTR_DIR/certs/rhcsa/container-cache-setup.sh" \
        || warn "Offline registry mirror not (yet) configured on $vm — container tasks needing search/pull may fail without internet."
    fi
  else
    info "Creating VM: $vm (RHEL $RHEL_VERSION)"
    # Profiles are applied left-to-right; rhtr-rhcsa overrides what default sets.
    incus launch "$img" "$vm" --vm \
      --profile default \
      --profile "$profile"

    vm_wait_ready "$vm"

    # Pin grub's DEFAULT before any task setup runs — see grub-cleanup.sh for
    # why the base image otherwise leaves it ambiguous.
    vm_exec_script "$vm" "$RHTR_DIR/certs/rhcsa/grub-cleanup.sh" \
      || warn "grub-cleanup.sh failed on $vm — ch11-boot tasks using --update-kernel=DEFAULT may be unreliable"

    vm_exec_script "$vm" "$RHTR_DIR/certs/rhcsa/grub-serial-console.sh" \
      || warn "grub-serial-console.sh failed on $vm — the GRUB menu may not be visible over 'rhtr rhcsa console'"

    vm_exec_script "$vm" "$RHTR_DIR/certs/rhcsa/root-unlock.sh" \
      || warn "root-unlock.sh failed on $vm — sulogin-gated rescue/emergency targets (isolate-target-v1, repair-fstab-v1) may be unreachable"

    # Only pull in podman/the registry mirror when this session actually has
    # a container task — most profiles (networking, storage, lvm, ...) never
    # touch containers and shouldn't pay for this at VM creation.
    if [[ "${SESSION_NEEDS_CONTAINERS:-0}" == "1" ]]; then
      # Pre-load the container image used by all container tasks, and stand up
      # a local offline registry mirror (see container-cache-setup.sh) so
      # podman search/pull and skopeo inspect work with zero internet during
      # the actual exam. Done once at VM creation, while internet is available.
      # podman isn't present on the base image yet — install it first, or the
      # pull below fails with "command not found" and looks like a network issue.
      info "Installing podman..."
      vm_exec "$vm" dnf install -y podman </dev/null &>/dev/null

      info "Setting up offline container registry mirror (ubi9 + registry:2) — requires internet at setup time..."
      if vm_exec_script "$vm" "$RHTR_DIR/certs/rhcsa/container-cache-setup.sh"; then
        ok "Container tasks are ready to run fully offline"
      else
        warn "Could not fully set up the offline registry mirror — container tasks needing search/pull may fail without internet."
        warn "Retry once you have internet by re-running topology_create (it's idempotent)."
      fi
    fi

    # Attach the block disks and wait for udev so storage setup scripts see them immediately.
    for i in "${!sizes[@]}"; do
      disk=$(_rhcsa_disk_name "$((i + 1))")
      incus config device add "$vm" "extradisk$((i + 1))" disk pool=default source="$disk"
    done
    [[ ${#sizes[@]} -gt 0 ]] && vm_exec "$vm" udevadm settle
  fi

  ok "VM $vm ready"
}

topology_destroy() {
  local vm; vm=$(_rhcsa_vm_name)

  vm_delete "$vm"

  # Enumerate rather than relying on remembered count/sizes — destroy can run
  # in a fresh shell with no EXTRA_DISK_SIZES_GIB set.
  local disk
  while IFS= read -r disk; do
    [[ -z "$disk" ]] && continue
    incus storage volume delete default "$disk" 2>/dev/null || true
  done < <(incus storage volume list default --format csv -c n 2>/dev/null \
             | grep "^rhtr-rhcsa-disk-${RHEL_VERSION}-")

  ok "Topology destroyed"
}
