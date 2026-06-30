#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$CFG_FILE" ]]       || fail "ansible.cfg not found at $CFG_FILE"
[[ -f "$INVENTORY_FILE" ]] || fail "inventory not found at $INVENTORY_FILE"

grep -q "inventory" "$CFG_FILE" \
  || fail "ansible.cfg does not set inventory"
grep -qi "remote_user\s*=\s*student" "$CFG_FILE" \
  || fail "ansible.cfg does not set remote_user = student"
grep -qi "host_key_checking\s*=\s*[Ff]alse" "$CFG_FILE" \
  || fail "ansible.cfg does not disable host_key_checking"

# inventory group membership checks
cd "$ANSIBLE_DIR"
_inv_graph=$(ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null) || fail "ansible-inventory parse failed"

echo "$_inv_graph" | grep -q "node1" || fail "node1 not in inventory"
echo "$_inv_graph" | grep -q "node2" || fail "node2 not in inventory"
echo "$_inv_graph" | grep -q "node3" || fail "node3 not in inventory"
echo "$_inv_graph" | grep -q "node4" || fail "node4 not in inventory"
echo "$_inv_graph" | grep -q "node5" || fail "node5 not in inventory"

ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A5 "@dev" | grep -q "node1" \
  || fail "node1 is not in the dev group"
ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A5 "@test" | grep -q "node2" \
  || fail "node2 is not in the test group"
ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A5 "@prod" | grep -q "node3" \
  || fail "node3 is not in the prod group"
ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A5 "@prod" | grep -q "node4" \
  || fail "node4 is not in the prod group"
ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A5 "@balancers" | grep -q "node5" \
  || fail "node5 is not in the balancers group"
ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -B2 "@prod" | grep -q "webservers" \
  || fail "prod is not a child of webservers"

# connectivity check
su - student -c "cd $ANSIBLE_DIR && ansible all -m ping -o" &>/dev/null \
  || fail "ansible ping failed — check SSH connectivity to managed nodes"

[[ $errors -eq 0 ]] && exit 0 || exit 1
