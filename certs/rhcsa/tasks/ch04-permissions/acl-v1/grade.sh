#!/usr/bin/env bash
set -euo pipefail
errors=0

fail() { echo "FAIL: $*"; (( errors++ )); }

acls=$(getfacl /var/data/reports 2>/dev/null)
defacls=$(getfacl /var/data/reports 2>/dev/null | grep '^default:')

# auditor has r-x (no write)
echo "$acls" | grep -q '^user:auditor:r-x' \
  || fail "auditor does not have r-x ACL on /var/data/reports (got: $(echo "$acls" | grep auditor || echo none))"

# contractors has --- (no access)
echo "$acls" | grep -q '^group:contractors:---' \
  || fail "contractors does not have --- ACL on /var/data/reports (got: $(echo "$acls" | grep contractors || echo none))"

# Default ACL: auditor r-x
echo "$defacls" | grep -q 'default:user:auditor:r-x' \
  || fail "no default ACL for auditor on /var/data/reports"

# Default ACL: contractors ---
echo "$defacls" | grep -q 'default:group:contractors:---' \
  || fail "no default ACL for contractors on /var/data/reports"

[[ $errors -eq 0 ]] && exit 0 || exit 1
