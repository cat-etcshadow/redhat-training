#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# no-arg exits 1
"$SCRIPT_PATH" &>/dev/null && fail "no-arg should exit non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "no-arg exit code is $rc, expected 1"

# re-establish preconditions ourselves — a prior manual test run of the
# script must not invalidate this check, so don't rely solely on setup.sh
# having run exactly once at session start
useradd -M rhtr_wh_alice 2>/dev/null || true
for u in rhtr_wh_bob rhtr_wh_carol rhtr_wh_dave; do
  userdel -r "$u" 2>/dev/null || true
done
cat > "$INPUT_FILE" <<'EOF'
rhtr_wh_alice
rhtr_wh_bob
rhtr_wh_carol
rhtr_wh_dave
EOF

# run with the input file
out=$("$SCRIPT_PATH" "$INPUT_FILE") && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "script exited $rc when run with valid file"

# rhtr_wh_alice already existed — should be SKIP
echo "$out" | grep -qi 'skip.*rhtr_wh_alice\|rhtr_wh_alice.*skip\|already exist' \
  || fail "rhtr_wh_alice should have been skipped (already exists)"

# others should have been created
for user in rhtr_wh_bob rhtr_wh_carol rhtr_wh_dave; do
  id "$user" &>/dev/null || fail "user $user was not created"
  echo "$out" | grep -qi "created.*${user}\|${user}.*created" \
    || fail "no CREATED line for $user in output"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
