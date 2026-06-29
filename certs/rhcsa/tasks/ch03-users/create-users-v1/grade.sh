#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

getent group "$GROUP" | grep -q ":${GID}:" \
  || fail "group $GROUP with GID $GID not found"

id "$USER1" &>/dev/null || fail "user $USER1 does not exist"
[[ "$(id -u "$USER1")" == "$UID1" ]] || fail "$USER1 has wrong UID $(id -u "$USER1"), expected $UID1"
id "$USER1" | grep -q "$GROUP"       || fail "$USER1 is not a supplementary member of $GROUP"

id "$USER2" &>/dev/null || fail "user $USER2 does not exist"
[[ "$(id -u "$USER2")" == "$UID2" ]] || fail "$USER2 has wrong UID $(id -u "$USER2"), expected $UID2"
id "$USER2" | grep -q "$GROUP"       || fail "$USER2 is not a supplementary member of $GROUP"

hash1=$(getent shadow "$USER1" 2>/dev/null | cut -d: -f2)
[[ "$hash1" =~ ^\$ ]] || fail "$USER1 has no password set"

hash2=$(getent shadow "$USER2" 2>/dev/null | cut -d: -f2)
[[ "$hash2" =~ ^\$ ]] || fail "$USER2 has no password set"

sudo -l -U "$USER1" 2>/dev/null | grep -q 'NOPASSWD.*ALL\|NOPASSWD: ALL' \
  || fail "$USER1 does not have NOPASSWD sudo access"

[[ $errors -eq 0 ]] && exit 0 || exit 1
