#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# package must be installed
rpm -q "$LOCAL_PKG" &>/dev/null \
  || fail "package $LOCAL_PKG is not installed"

# local repo file must exist
[[ -f /etc/yum.repos.d/rhtr-local.repo ]] \
  || fail "/etc/yum.repos.d/rhtr-local.repo does not exist"

grep -qi 'baseurl.*file://' /etc/yum.repos.d/rhtr-local.repo \
  || fail "rhtr-local.repo does not have a file:// baseurl"

grep -qi "$LOCAL_REPO_DIR" /etc/yum.repos.d/rhtr-local.repo \
  || fail "rhtr-local.repo baseurl does not point to $LOCAL_REPO_DIR"

# repo metadata must exist (createrepo was run)
[[ -d "${LOCAL_REPO_DIR}/repodata" ]] \
  || fail "$LOCAL_REPO_DIR/repodata/ missing — run createrepo_c $LOCAL_REPO_DIR"

# repo must appear in dnf repolist
dnf repolist 2>/dev/null | grep -qi 'rhtr-local' \
  || fail "rhtr-local repo not visible in dnf repolist"

[[ $errors -eq 0 ]] && exit 0 || exit 1
