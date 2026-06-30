#!/usr/bin/env bash
# topology.sh — RHCE VM environment (EX294 / Ansible)
#
# Provides: topology_create, topology_destroy
# Reads:    RHEL_VERSION (set by exam.sh)
#
# Environment:
#   1 control node:    rhtr-rhce-control-<version>  (Rocky Linux, ansible installed)
#   3 managed nodes:   rhtr-rhce-node{1,2,3}-<version>
#
# Network layout (via Incus bridge):
#   control  → node1 (dev), node2 (test), node3 (prod), node4 (prod), node5 (balancers)
# SSH key auth from control → all nodes configured by topology_create.

_rhce_vm()      { echo "rhtr-rhce-${1}-${RHEL_VERSION}"; }
_rhce_img()     { echo "rocky${RHEL_VERSION}"; }
_rhce_profile() { echo "rhtr-rhce"; }

CONTROL_NAME=""
NODE_NAMES=()
VM_NAMES=()

topology_names() {
  CONTROL_NAME=$(_rhce_vm "control")
  NODE_NAMES=(
    $(_rhce_vm "node1")
    $(_rhce_vm "node2")
    $(_rhce_vm "node3")
    $(_rhce_vm "node4")
    $(_rhce_vm "node5")
  )
  VM_NAMES=("$CONTROL_NAME" "${NODE_NAMES[@]}")
}

topology_create() {
  topology_names

  local img; img=$(_rhce_img)
  local profile; profile=$(_rhce_profile)

  vm_require_image "$img"

  vm_profile_ensure "$profile" \
    "security.secureboot=false" \
    "limits.cpu=2" \
    "limits.memory=1GiB"

  # Create all VMs
  for vm in "${VM_NAMES[@]}"; do
    if vm_exists "$vm"; then
      vm_start "$vm"
    else
      info "Creating VM: $vm"
      incus launch "$img" "$vm" --vm \
        --profile default \
        --profile "$profile"
      vm_wait_ready "$vm"
    fi
  done

  # Bootstrap control node: create student user, install ansible
  info "Bootstrapping control node..."
  vm_exec "$CONTROL_NAME" bash -s <<'BOOTSTRAP'
set -euo pipefail
# create student user if needed
id student &>/dev/null || useradd -m -s /bin/bash student
echo "student:student" | chpasswd
echo "student ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/student

# install ansible-core
dnf install -y ansible-core python3-pip &>/dev/null

# generate SSH key for student
su - student -c 'test -f ~/.ssh/id_rsa || ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'
BOOTSTRAP

  # Bootstrap managed nodes: create student user, allow SSH from control
  local ctrl_pubkey
  ctrl_pubkey=$(incus exec "$CONTROL_NAME" -- su - student -c 'cat ~/.ssh/id_rsa.pub')

  for node in "${NODE_NAMES[@]}"; do
    info "Bootstrapping managed node: $node"
    vm_exec "$node" bash -s <<NODEBOOT
set -euo pipefail
id student &>/dev/null || useradd -m -s /bin/bash student
echo "student:student" | chpasswd
echo "student ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/student
mkdir -p /home/student/.ssh
echo "$ctrl_pubkey" >> /home/student/.ssh/authorized_keys
chmod 700 /home/student/.ssh
chmod 600 /home/student/.ssh/authorized_keys
chown -R student:student /home/student/.ssh
# install python3 for ansible
dnf install -y python3 &>/dev/null
NODEBOOT
  done

  # Add managed node IPs to /etc/hosts on control node
  info "Configuring /etc/hosts on control node..."
  for node in "${NODE_NAMES[@]}"; do
    local short; short="${node%%-"${RHEL_VERSION}"}"  # strip version suffix
    local ip; ip=$(incus info "$node" | awk '/inet /{print $2}' | cut -d/ -f1 | head -1)
    [[ -n "$ip" ]] && incus exec "$CONTROL_NAME" -- bash -c \
      "grep -q '$short' /etc/hosts || echo '$ip $short' >> /etc/hosts"
  done

  ok "RHCE topology ready. Control: $CONTROL_NAME. Nodes: ${NODE_NAMES[*]}"
}

topology_destroy() {
  topology_names
  for vm in "${VM_NAMES[@]}"; do
    vm_delete "$vm"
  done
  ok "RHCE topology destroyed"
}
