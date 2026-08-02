#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }
as_student() { su - student -c "$1"; }

size_to_bytes() {
  local num unit mult=1
  num=$(grep -oE '^[0-9.]+' <<<"$1"); unit=$(grep -oE '[A-Za-z]+$' <<<"$1")
  case "$unit" in GiB|G) mult=1073741824;; MiB|M) mult=1048576;; KiB|K) mult=1024;; esac
  awk -v n="$num" -v m="$mult" 'BEGIN{printf "%d", n*m}'
}

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "community\.general\.parted|parted:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use community.general.parted"
grep -qE "ansible\.builtin\.filesystem|filesystem:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use filesystem module"
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
    # nodesetup.sh sizes the raw disk at ~1000MiB — strictly between
    # FALLBACK_SIZE (800MiB) and PART_SIZE (1200MiB) — so a correct
    # playbook's block: (partitioning at PART_SIZE) always fails here and
    # its rescue: (partitioning at FALLBACK_SIZE) always runs.
    echo "$run_out" | grep -q "Could not create partition of that size" \
      || fail "rescue section did not appear to run — expected debug message 'Could not create partition of that size' not seen in playbook output"

    want_bytes=$(size_to_bytes "$FALLBACK_SIZE")

    part_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'lsblk -bno SIZE /dev/${DISK}1'" 2>&1)
    sizes=$(grep -oE '^[0-9]+$' <<<"$part_out")
    if [[ -z "$sizes" ]]; then
      fail "partition /dev/${DISK}1 not found on all prod hosts"
    else
      bad=0
      while read -r val; do
        (( val >= want_bytes*80/100 && val <= want_bytes*120/100 )) || bad=1
      done <<<"$sizes"
      [[ $bad -eq 0 ]] || fail "partition /dev/${DISK}1 size is not close to the fallback size ($FALLBACK_SIZE) on all prod hosts"
    fi

    fs_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'blkid -o value -s TYPE /dev/${DISK}1'" 2>&1)
    fs_count=$(grep -cxF "$FS_TYPE" <<<"$fs_out")
    [[ "$fs_count" -ge 2 ]] \
      || fail "partition /dev/${DISK}1 is not formatted as $FS_TYPE on all prod hosts"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
