#!/usr/bin/env bash
# topology.sh — RHCE VM environment (EX294 / Ansible)
#
# Provides: topology_create, topology_destroy
# Reads:    RHEL_VERSION (set by exam.sh)
#           NODE_COUNT   (set by exam.sh from --nodes, default 5)
#
# Environment:
#   1 control node:    rhtr-rhce-control-<version>  (Rocky Linux, ansible-core +
#                       ansible-navigator + podman + git installed)
#   1-5 managed nodes: rhtr-rhce-node{1..NODE_COUNT}-<version>
#
# Network layout (via Incus bridge), at the full NODE_COUNT=5:
#   control  → node1 (dev), node2 (test), node3 (prod), node4 (prod), node5 (balancers)
# SSH key auth from control → all nodes configured by topology_create.
#
# NOTE: most task setup/grade scripts hardcode a 5-node inventory (node1-5,
# dev/test/prod/balancers groups). lib/exam.sh's _filter_tasks_by_node_count
# drops any selected task that references a node beyond NODE_COUNT (and warns
# about what it dropped), so --profile full/--fixed/--topic + --nodes N just
# runs the subset of that selection that fits in N nodes — it does not need
# to be combined with a topic already scoped to fewer nodes.

_rhce_vm()      { echo "rhtr-rhce-${1}-${RHEL_VERSION}"; }
_rhce_img()     { echo "rocky${RHEL_VERSION}"; }
_rhce_profile() { echo "rhtr-rhce"; }

CONTROL_NAME=""
NODE_NAMES=()
VM_NAMES=()

topology_names() {
  local node_count="${NODE_COUNT:-5}"
  [[ "$node_count" =~ ^[1-5]$ ]] || die "Invalid NODE_COUNT '$node_count' — must be 1-5"

  CONTROL_NAME=$(_rhce_vm "control")
  NODE_NAMES=()
  local i
  for (( i=1; i<=node_count; i++ )); do
    NODE_NAMES+=("$(_rhce_vm "node$i")")
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
  ok "RHCE topology destroyed"
}
