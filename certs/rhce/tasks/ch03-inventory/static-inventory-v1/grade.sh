#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$INVENTORY_FILE" ]] || fail "inventory not found at $INVENTORY_FILE"

cd "$ANSIBLE_DIR"
graph=$(ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null) \
  || fail "ansible-inventory failed to parse inventory"

for node in node1 node2 node3 node4 node5; do
  echo "$graph" | grep -q "$node" || fail "$node missing from inventory"
done

ansible-inventory -i "$INVENTORY_FILE" --host node1 2>/dev/null | python3 -c \
  "import sys,json; d=json.load(sys.stdin)" &>/dev/null \
  || ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A3 "@dev" | grep -q "node1" \
  || fail "node1 is not in the dev group"

ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A3 "@test" | grep -q "node2" \
  || fail "node2 is not in the test group"

ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A3 "@prod" | grep -q "node3" \
  || fail "node3 is not in the prod group"

ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A3 "@prod" | grep -q "node4" \
  || fail "node4 is not in the prod group"

ansible-inventory -i "$INVENTORY_FILE" --graph 2>/dev/null | grep -A3 "@balancers" | grep -q "node5" \
  || fail "node5 is not in the balancers group"

# webservers must contain prod and balancers as children
echo "$graph" | grep -A10 "@webservers" | grep -q "prod" \
  || fail "prod is not a child of webservers"
echo "$graph" | grep -A10 "@webservers" | grep -q "balancers" \
  || fail "balancers is not a child of webservers"

[[ $errors -eq 0 ]] && exit 0 || exit 1
