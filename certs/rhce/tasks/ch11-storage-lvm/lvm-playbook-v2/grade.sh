#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }
as_student() { su - student -c "$1"; }

size_to_mib() {
  local num unit
  num=$(grep -oE '^[0-9.]+' <<<"$1"); unit=$(grep -oE '[A-Za-z]+$' <<<"$1")
  case "$unit" in
    g|G) awk -v n="$num" 'BEGIN{printf "%d", n*1024}' ;;
    *)   awk -v n="$num" 'BEGIN{printf "%d", n}' ;;
  esac
}

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "community\.general\.lvol|lvol:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use community.general.lvol"
grep -qE "ansible\.builtin\.mount|mount:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use ansible.builtin.mount"
grep -qE "state:\s*mounted" "$PLAYBOOK_FILE" \
  || fail "mount module does not use state: mounted (required for persistent mount)"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    want_mib=$(size_to_mib "$LV_SIZE")

    lv_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'lvs --noheadings --units m --nosuffix -o lv_size $VG_NAME/$LV_NAME'" 2>&1)
    sizes=$(grep -oE '^[0-9]+\.[0-9]+$' <<<"$lv_out")
    if [[ -z "$sizes" ]]; then
      fail "logical volume $VG_NAME/$LV_NAME not found on all prod hosts"
    else
      bad=0
      while read -r val; do
        ival=${val%.*}
        (( ival >= want_mib*80/100 && ival <= want_mib*120/100 )) || bad=1
      done <<<"$sizes"
      [[ $bad -eq 0 ]] || fail "logical volume $VG_NAME/$LV_NAME size is not close to LV_SIZE ($LV_SIZE) on all prod hosts"
    fi

    mount_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'findmnt -n -o SOURCE,FSTYPE $MOUNT_POINT'" 2>&1)
    match_count=$(grep -cF "/dev/$VG_NAME/$LV_NAME $FS_TYPE" <<<"$mount_out")
    [[ "$match_count" -ge 2 ]] \
      || fail "$MOUNT_POINT is not mounted from /dev/$VG_NAME/$LV_NAME as $FS_TYPE on all prod hosts"

    fstab_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'grep -F /dev/$VG_NAME/$LV_NAME /etc/fstab'" 2>&1)
    fstab_count=$(grep -cF "/dev/$VG_NAME/$LV_NAME" <<<"$fstab_out")
    [[ "$fstab_count" -ge 2 ]] \
      || fail "mount is not persisted in /etc/fstab on all prod hosts"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
