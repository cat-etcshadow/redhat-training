#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

GV="$ANSIBLE_DIR/group_vars"

[[ -d "$GV" ]] || fail "group_vars directory does not exist under $ANSIBLE_DIR"

for group in dev test prod all; do
  [[ -f "$GV/$group.yml" || -f "$GV/$group/main.yml" ]] \
    || fail "group_vars file missing for group: $group"
done

cd "$ANSIBLE_DIR"
_check_var() {
  local host="$1" var="$2" expected="$3"
  local val
  val=$(ansible-inventory -i "$INVENTORY_FILE" --host "$host" 2>/dev/null | python3 -c \
    "import sys,json; d=json.load(sys.stdin); print(d.get('$var',''))")
  [[ "$val" == "$expected" ]] || fail "$host: expected $var=$expected, got '$val'"
}

_check_var node1 env "$DEV_ENV"
_check_var node2 env "$TEST_ENV"
_check_var node3 env "$PROD_ENV"
_check_var node1 ntp_server "172.25.254.250"
_check_var node3 ntp_server "172.25.254.250"

[[ $errors -eq 0 ]] && exit 0 || exit 1
