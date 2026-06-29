#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

rpm -q nfs-utils &>/dev/null || fail "nfs-utils is not installed"
[[ -d /mnt/nfsshare ]] || fail "/mnt/nfsshare directory does not exist"

grep -q 'nfsserver.example.com:/exports/shared' /etc/fstab \
  || fail "NFS share not found in /etc/fstab"

fstab_entry=$(grep 'nfsserver.example.com:/exports/shared' /etc/fstab)
echo "$fstab_entry" | grep -q '/mnt/nfsshare' \
  || fail "fstab entry does not mount to /mnt/nfsshare"
echo "$fstab_entry" | grep -q 'nfsvers=4' \
  || fail "fstab entry missing nfsvers=4 option"
echo "$fstab_entry" | grep -q 'soft' \
  || fail "fstab entry missing 'soft' option"
echo "$fstab_entry" | grep -q 'timeo=30' \
  || fail "fstab entry missing timeo=30 option"

[[ $errors -eq 0 ]] && exit 0 || exit 1
