#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }
as_student() { su - student -c "$1"; }

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "community\.general\.sefcontext|^[[:space:]]*sefcontext:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the sefcontext module"
grep -qE "ansible\.posix\.seboolean|^[[:space:]]*seboolean:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the seboolean module"
grep -q "persistent: yes" "$PLAYBOOK_FILE" \
  || fail "SELinux boolean not set to persistent"
grep -q "restorecon" "$PLAYBOOK_FILE" \
  || fail "restorecon not called to apply file context"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    policy_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'semanage fcontext -l'" 2>&1)
    fcontext_hits=$(echo "$policy_out" | grep -F "${CUSTOM_DIR}(/.*)?" | grep -c "$SELINUX_TYPE")
    [[ "$fcontext_hits" -eq 2 ]] \
      || fail "no semanage fcontext rule for ${CUSTOM_DIR}(/.*)? with type $SELINUX_TYPE on both prod hosts"

    ctx_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'ls -Zd $CUSTOM_DIR/index.html'" 2>&1)
    relabel_hits=$(echo "$ctx_out" | grep -c "$SELINUX_TYPE")
    [[ "$relabel_hits" -eq 2 ]] \
      || fail "existing file under $CUSTOM_DIR was not relabeled to $SELINUX_TYPE on both prod hosts"

    sebool_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'getsebool $SELINUX_BOOLEAN'" 2>&1)
    if echo "$sebool_out" | grep -q -- "--> off"; then
      fail "SELinux boolean $SELINUX_BOOLEAN is not enabled on all prod hosts"
    elif [[ "$(echo "$sebool_out" | grep -c -- "--> on")" -ne 2 ]]; then
      fail "could not confirm SELinux boolean $SELINUX_BOOLEAN is enabled on both prod hosts"
    fi
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
