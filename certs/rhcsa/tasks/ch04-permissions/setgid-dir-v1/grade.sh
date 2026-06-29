#!/usr/bin/env bash
set -euo pipefail
errors=0

fail() { echo "FAIL: $*"; (( errors++ )); }

# Group webteam exists
getent group webteam &>/dev/null || fail "group webteam does not exist"

# /srv/webshared exists
[[ -d /srv/webshared ]] || fail "/srv/webshared does not exist"

# Owned by root:webteam
owner=$(stat -c '%U' /srv/webshared)
group=$(stat -c '%G' /srv/webshared)
[[ "$owner" == "root"    ]] || fail "/srv/webshared owner is $owner, expected root"
[[ "$group" == "webteam" ]] || fail "/srv/webshared group is $group, expected webteam"

# Mode 2770 (setgid + 770)
mode=$(stat -c '%a' /srv/webshared)
[[ "$mode" == "2770" ]] || fail "/srv/webshared mode is $mode, expected 2770"

# webdev exists and is in webteam
id webdev &>/dev/null               || fail "user webdev does not exist"
id webdev | grep -q 'webteam'       || fail "webdev is not in group webteam"

# File created by webdev inherits webteam group
tmp_file=$(sudo -u webdev bash -c 'touch /srv/webshared/testfile_grade && echo /srv/webshared/testfile_grade')
file_group=$(stat -c '%G' "$tmp_file" 2>/dev/null)
rm -f "$tmp_file"
[[ "$file_group" == "webteam" ]] \
  || fail "file created in /srv/webshared has group $file_group, expected webteam (SGID not working)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
