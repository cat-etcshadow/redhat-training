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

# verify the password is set to the required value, not just that some hash exists
check_pw() {
  local user="$1" hash
  hash=$(getent shadow "$user" 2>/dev/null | cut -d: -f2)
  [[ "$hash" =~ ^\$ ]] || { fail "$user has no password set"; return; }
  python3 -c "import crypt,sys; h=sys.argv[1]; sys.exit(0 if crypt.crypt(sys.argv[2],h)==h else 1)" \
    "$hash" "$PASSWORD" || fail "$user password does not match the required value"
}
check_pw "$USER1"
check_pw "$USER2"

sudo -l -U "$USER1" 2>/dev/null | grep -q 'NOPASSWD.*ALL\|NOPASSWD: ALL' \
  || fail "$USER1 does not have NOPASSWD sudo access"

[[ $errors -eq 0 ]] && exit 0 || exit 1
