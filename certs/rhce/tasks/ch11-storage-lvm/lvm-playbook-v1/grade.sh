#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }
as_student() { su - student -c "$1"; }

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "community\.general\.lvol|lvol:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use community.general.lvol"
grep -qE "block:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain a block: section"
grep -qE "rescue:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain a rescue: section"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    # nodesetup.sh pre-sizes the VG to 1000 MiB free — strictly between
    # FALLBACK_SIZE (800m) and LV_SIZE (1200m) — so a correct playbook's
    # block: always fails here and its rescue: always runs.
    echo "$run_out" | grep -q "could not create logical volume of that size" \
      || fail "rescue section did not appear to run — expected debug message 'could not create logical volume of that size' not seen in playbook output"

    lv_out=$(as_student "ansible all -i $INVENTORY_FILE -m command -a 'lvs --noheadings --units m --nosuffix -o lv_size $VG_NAME/$LV_NAME'" 2>&1)
    sizes=$(grep -oE '^[0-9]+\.[0-9]+$' <<<"$lv_out")
    if [[ -z "$sizes" ]]; then
      fail "logical volume $VG_NAME/$LV_NAME not found on all hosts"
    else
      bad=0
      while read -r val; do
        ival=${val%.*}
        (( ival >= 700 && ival <= 900 )) || bad=1
      done <<<"$sizes"
      [[ $bad -eq 0 ]] || fail "logical volume $VG_NAME/$LV_NAME is not sized close to the fallback size ($FALLBACK_SIZE) on all hosts"
    fi

    fs_out=$(as_student "ansible all -i $INVENTORY_FILE -m command -a 'blkid -o value -s TYPE /dev/$VG_NAME/$LV_NAME'" 2>&1)
    echo "$fs_out" | grep -q "$FS_TYPE" \
      || fail "logical volume $VG_NAME/$LV_NAME is not formatted as $FS_TYPE on all hosts"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
