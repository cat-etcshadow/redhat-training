#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }
as_student() { su - student -c "$1"; }

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "ansible\.builtin\.group|^[[:space:]]*group:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the group module"
grep -qE "ansible\.builtin\.user|^[[:space:]]*user:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the user module"
grep -qE "ansible\.posix\.authorized_key|^[[:space:]]*authorized_key:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use authorized_key module"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    grp_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'getent group $GROUP_NAME'" 2>&1)
    [[ "$(echo "$grp_out" | grep -c ":$GROUP_GID:")" -eq 2 ]] \
      || fail "group $GROUP_NAME with GID $GROUP_GID does not exist on both prod hosts"

    usr_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'getent passwd $USER_NAME'" 2>&1)
    [[ "$(echo "$usr_out" | grep -c ":$USER_UID:")" -eq 2 ]] \
      || fail "user $USER_NAME with UID $USER_UID does not exist on both prod hosts"
    [[ "$(echo "$usr_out" | grep -F -c "$USER_SHELL")" -eq 2 ]] \
      || fail "user $USER_NAME does not have shell $USER_SHELL on both prod hosts"

    key_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'cat /home/$USER_NAME/.ssh/authorized_keys'" 2>&1)
    [[ "$(echo "$key_out" | grep -F -c 'ansible-training')" -eq 2 ]] \
      || fail "SSH key not deployed to $USER_NAME's authorized_keys on both prod hosts"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
