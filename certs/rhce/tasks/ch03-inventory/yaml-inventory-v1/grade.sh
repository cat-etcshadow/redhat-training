#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$YAML_INVENTORY_FILE" ]] \
  || fail "YAML inventory not found at $YAML_INVENTORY_FILE"

python3 -c "import yaml,sys; yaml.safe_load(open('$YAML_INVENTORY_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $YAML_INVENTORY_FILE"

_graph=$(ansible-inventory -i "$YAML_INVENTORY_FILE" --graph 2>/dev/null) \
  || fail "ansible-inventory failed to parse $YAML_INVENTORY_FILE"

for node in node1 node2 node3 node4 node5; do
  echo "$_graph" | grep -q "$node" || fail "$node not found in YAML inventory graph"
done

for grp in dev test prod balancers webservers; do
  echo "$_graph" | grep -q "@${grp}" || fail "group '$grp' not found in YAML inventory graph"
done

echo "$_graph" | grep -A5 "@webservers" | grep -qE "prod|balancers" \
  || fail "webservers group does not contain prod or balancers as children"

[[ $errors -eq 0 ]] && exit 0 || exit 1
