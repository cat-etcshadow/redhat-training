#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -d "$ANSIBLE_DIR/host_vars" ]] \
  || fail "host_vars directory not found at $ANSIBLE_DIR/host_vars"

[[ -f "$ANSIBLE_DIR/host_vars/node1.yml" ]] \
  || fail "host_vars/node1.yml does not exist"

[[ -f "$ANSIBLE_DIR/host_vars/node2.yml" ]] \
  || fail "host_vars/node2.yml does not exist"

grep -qE "http_port\s*:\s*8080" "$ANSIBLE_DIR/host_vars/node1.yml" \
  || fail "node1.yml does not set http_port: 8080"

grep -qE "http_port\s*:\s*9090" "$ANSIBLE_DIR/host_vars/node2.yml" \
  || fail "node2.yml does not set http_port: 9090"

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook not found at $PLAYBOOK_FILE"

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "syntax check failed"

grep -qE "http_port" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference http_port variable"

grep -qE "debug" "$PLAYBOOK_FILE" \
  || fail "playbook does not use debug module"

[[ $errors -eq 0 ]] && exit 0 || exit 1
