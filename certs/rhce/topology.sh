#!/usr/bin/env bash
# topology.sh — RHCE VM environment (EX294 / Ansible)
#
# Provides: topology_create, topology_destroy
# Reads:    RHEL_VERSION   (set by exam.sh)
#           SESSION_NODES  (space-separated e.g. "node1 node3 node4" — set by
#                           lib/exam.sh's _assign_task_nodes from the union of
#                           every selected task's NEEDS_NODES, persisted into
#                           exam.conf so it survives across commands)
#
# Environment:
#   1 control node: rhtr-rhce-control-<version>  (Rocky Linux, ansible-core +
#                    ansible-navigator + podman + git installed)
#   managed nodes:   rhtr-rhce-<node>-<version> for each node in SESSION_NODES
#                    — only the union of nodes the selected task set actually
#                    declares gets built, not always all 5.
#
# Full node layout (dev=node1, test=node2, prod=node3+node4, balancers=node5):
#   control  → node1 (dev), node2 (test), node3 (prod), node4 (prod), node5 (balancers)
# SSH key auth from control → all built nodes configured by topology_create.

_rhce_vm()      { echo "rhtr-rhce-${1}-${RHEL_VERSION}"; }
_rhce_img()     { echo "rocky${RHEL_VERSION}"; }
_rhce_profile() { echo "rhtr-rhce"; }
# $1 = sanitized task slug (ch11-storage-lvm__lvm-playbook-v1 -> ch11-storage-lvm-lvm-playbook-v1), $2 = node
_rhce_disk_name() { echo "rhtr-rhce-disk-${RHEL_VERSION}-${1}-${2}"; }

CONTROL_NAME=""
NODE_NAMES=()
VM_NAMES=()

# Populate VM_NAMES from $SESSION_NODES (persisted in exam.conf, sourced by
# every caller before this runs — see cmd_shell/cmd_console/cmd_grade/
# cmd_reset/cmd_destroy in lib/exam.sh). Falls back to the full 5-node set
# when SESSION_NODES is unset (e.g. no active session yet).
topology_names() {
  CONTROL_NAME=$(_rhce_vm "control")
  NODE_NAMES=()
  local n
  for n in ${SESSION_NODES:-node1 node2 node3 node4 node5}; do
    NODE_NAMES+=("$(_rhce_vm "$n")")
  done
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

  # Attach any per-task disks to the managed node(s) that task targets — see
  # lib/exam.sh's _assign_task_disks, which writes this file as
  # slug|size_gib|nodes|size_mib (nodes/size_mib empty unless the task
  # declares NEEDS_NODES/NEEDS_DISK_SIZE_MIB). Idempotent: safe to call again
  # on VM reuse, mirroring certs/rhcsa/topology.sh's re-attach check.
  if [[ -f "$STATE_DIR/task-disks.txt" ]]; then
    local _slug _size_gib _nodes _size_mib
    while IFS='|' read -r _slug _size_gib _nodes _size_mib; do
      [[ -n "$_nodes" ]] || continue
      local _size; _size="${_size_mib:+${_size_mib}MiB}"; _size="${_size:-${_size_gib}GiB}"
      local _safe_slug="${_slug//__/-}"
      local _node
      for _node in $_nodes; do
        local _node_vm; _node_vm=$(_rhce_vm "$_node")
        local _disk; _disk=$(_rhce_disk_name "$_safe_slug" "$_node")
        local _device_name; _device_name="taskdisk-${_safe_slug}"
        if ! incus storage volume info default "$_disk" &>/dev/null; then
          info "Creating task disk: $_disk ($_size) for $_node_vm"
          incus storage volume create default "$_disk" --type=block size="$_size"
        fi
        if ! grep -q "^${_device_name}:" <<<"$(incus config device show "$_node_vm")"; then
          incus config device add "$_node_vm" "$_device_name" disk pool=default source="$_disk"
          vm_exec "$_node_vm" udevadm settle
        fi
      done
    done < "$STATE_DIR/task-disks.txt"
  fi

  # Bootstrap control node: create student user, install ansible
  info "Bootstrapping control node..."
  vm_exec "$CONTROL_NAME" bash -s <<'BOOTSTRAP'
set -euo pipefail
# create student user if needed
id student &>/dev/null || useradd -m -s /bin/bash student
echo "student:student" | chpasswd
echo "student ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/student

# install ansible-core, ansible-navigator (+ EE support), git
dnf install -y ansible-core python3-pip podman git &>/dev/null
pip3 install --quiet ansible-navigator &>/dev/null

# ansible-core alone ships no collections — every task playbook in this cert
# depends on community.general (nmcli, lvol, parted, sefcontext) and
# ansible.posix (firewalld, seboolean, authorized_key, sysctl) modules
su - student -c 'ansible-galaxy collection install community.general ansible.posix' &>/dev/null

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
# install python3 for ansible, plus the module deps ch04/ch11 playbooks need:
# python3-firewall (firewalld module), policycoreutils-python-utils
# (sefcontext/seboolean's semanage/setsebool), NetworkManager (nmcli module)
dnf install -y python3 firewalld python3-firewall policycoreutils-python-utils NetworkManager &>/dev/null
systemctl enable --now firewalld NetworkManager &>/dev/null
NODEBOOT
  done

  # Add managed node IPs to /etc/hosts on control node
  info "Configuring /etc/hosts on control node..."
  for node in "${NODE_NAMES[@]}"; do
    # inventory hostnames are the bare node names (node1..node5); strip both the
    # rhtr-rhce- prefix and the -<version> suffix off the full VM name
    local short; short="${node#rhtr-rhce-}"; short="${short%-"${RHEL_VERSION}"}"
    local ip; ip=$(incus info "$node" | awk '/inet:/{print $2}' | cut -d/ -f1 | head -1)
    [[ -n "$ip" ]] || die "Could not determine IP for $node — 'incus info' output format may have changed; check the awk pattern above"
    incus exec "$CONTROL_NAME" -- bash -c \
      "grep -qw '$short' /etc/hosts || echo '$ip $short' >> /etc/hosts"
  done

  ok "RHCE topology ready. Control: $CONTROL_NAME. Nodes: ${NODE_NAMES[*]}"
}

topology_destroy() {
  topology_names
  for vm in "${VM_NAMES[@]}"; do
    vm_delete "$vm"
  done

  # Enumerate rather than relying on task-disks.txt — destroy can run in a
  # fresh shell with no active session state, same reasoning as RHCSA's
  # topology_destroy (certs/rhcsa/topology.sh).
  local disk
  while IFS= read -r disk; do
    [[ -z "$disk" ]] && continue
    incus storage volume delete default "$disk" 2>/dev/null || true
  done < <(incus storage volume list default --format csv -c n 2>/dev/null \
             | grep "^rhtr-rhce-disk-${RHEL_VERSION}-")

  ok "RHCE topology destroyed"
}
