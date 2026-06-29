#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

getent group "$GROUP" | grep -q ":${GID}:" \
  || fail "group $GROUP with GID $GID not found"

id "$USER1" &>/dev/null || fail "user $USER1 does not exist"
[[ "$(id -u "$USER1")" == "$UID1" ]] || fail "$USER1 has wrong UID $(id -u "$USER1"), expected $UID1"
id "$USER1" | grep -q "$GROUP"       || fail "$USER1 is not in group $GROUP"

shadow1=$(getent shadow "$USER1")
hash1=$(echo "$shadow1" | cut -d: -f2)
[[ "$hash1" =~ ^\$ ]] || fail "$USER1 has no password set"

max=$(echo "$shadow1"  | cut -d: -f5)
warn=$(echo "$shadow1" | cut -d: -f6)
inac=$(echo "$shadow1" | cut -d: -f7)
[[ "$max"  == "$MAX_AGE"   ]] || fail "$USER1 password max age is $max, expected $MAX_AGE"
[[ "$warn" == "$WARN_DAYS" ]] || fail "$USER1 password warning days is $warn, expected $WARN_DAYS"
[[ "$inac" == "$INACTIVE"  ]] || fail "$USER1 inactive days is $inac, expected $INACTIVE"

id "$USER2" &>/dev/null || fail "user $USER2 does not exist"
[[ "$(id -u "$USER2")" == "$UID2" ]] || fail "$USER2 has wrong UID $(id -u "$USER2"), expected $UID2"
id "$USER2" | grep -q "$GROUP"       || fail "$USER2 is not in group $GROUP"

shell2=$(getent passwd "$USER2" | cut -d: -f7)
[[ "$shell2" == "/bin/sh" ]] || fail "$USER2 shell is $shell2, expected /bin/sh"

hash2=$(getent shadow "$USER2" | cut -d: -f2)
[[ "$hash2" == !* ]] || fail "$USER2 account is not locked (shadow: $hash2)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
