#!/usr/bin/env bash
# topology.sh — RHCSA VM environment
#
# Provides: topology_create, topology_destroy
# Reads:    RHEL_VERSION (set by exam.sh from --rhel flag or cert default)
#
# Environment:
#   1 VM:   rhtr-rhcsa-server-<version>  (Rocky Linux, SELinux enforcing)
#   1 disk: rhtr-rhcsa-disk-<version>   (4 GiB block volume for storage/LVM tasks)
#
# Incus profile "rhtr-rhcsa" is created once and reused across sessions.
# It captures all VM-level config so incus launch stays a one-liner.

_rhcsa_vm_name()      { echo "rhtr-rhcsa-server-${RHEL_VERSION}"; }
_rhcsa_disk_name()    { echo "rhtr-rhcsa-disk-${RHEL_VERSION}"; }
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
  local disk;    disk=$(_rhcsa_disk_name)
  local img;     img=$(_rhcsa_image)
  local profile; profile=$(_rhcsa_profile_name)

  VM_NAMES=("$vm")

  vm_require_image "$img"

  # Ensure the shared profile exists with current settings (idempotent)
  vm_profile_ensure "$profile" \
    "security.secureboot=false" \
    "limits.cpu=2" \
    "limits.memory=2GiB"

  # Create block volume before the VM so it is ready to attach immediately after launch.
  if ! incus storage volume info default "$disk" &>/dev/null; then
    info "Creating block disk: $disk (4 GiB)"
    incus storage volume create default "$disk" --type=block size=4GiB
  fi

  if vm_exists "$vm"; then
    info "VM $vm already exists — starting..."
    vm_start "$vm"
    # Re-attach disk if it was removed; run udevadm settle so the OS sees it.
    if ! incus config device show "$vm" | grep -q "extradisk"; then
      incus config device add "$vm" extradisk disk pool=default source="$disk"
      vm_exec "$vm" udevadm settle
    fi
  else
    info "Creating VM: $vm (RHEL $RHEL_VERSION)"
    # Profiles are applied left-to-right; rhtr-rhcsa overrides what default sets.
    incus launch "$img" "$vm" --vm \
      --profile default \
      --profile "$profile"

    vm_wait_ready "$vm"

    # Pre-load the container image used by all container tasks.
    # Done once at VM creation so tasks run fully offline during the exam.
    info "Pre-loading container image (ubi9) — requires internet at setup time..."
    if vm_exec "$vm" podman pull registry.access.redhat.com/ubi9/ubi </dev/null &>/dev/null; then
      vm_exec "$vm" podman save -o /var/cache/rhtr-ubi9.tar registry.access.redhat.com/ubi9/ubi </dev/null &>/dev/null || true
      ok "Container image cached at /var/cache/rhtr-ubi9.tar"
    else
      warn "Could not pull ubi9 image — container tasks will need internet at task setup time."
      warn "To cache it now:  incus exec $vm -- podman pull registry.access.redhat.com/ubi9/ubi"
      warn "Then save cache:  incus exec $vm -- podman save -o /var/cache/rhtr-ubi9.tar registry.access.redhat.com/ubi9/ubi"
    fi

    # Attach the block disk and wait for udev so storage setup scripts see it immediately.
    incus config device add "$vm" extradisk disk pool=default source="$disk"
    vm_exec "$vm" udevadm settle
  fi

  ok "VM $vm ready"
}

topology_destroy() {
  local vm;   vm=$(_rhcsa_vm_name)
  local disk; disk=$(_rhcsa_disk_name)

  vm_delete "$vm"
  incus storage volume delete default "$disk" 2>/dev/null || true

  ok "Topology destroyed"
}
