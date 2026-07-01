#!/usr/bin/env bash
dnf install -y dnf-plugins-core createrepo_c &>/dev/null
dnf remove -y "$PKG" &>/dev/null || true

rm -rf "$LOCAL_REPO_DIR"
mkdir -p "$LOCAL_REPO_DIR"
dnf download --destdir "$LOCAL_REPO_DIR" "$PKG" &>/dev/null \
  || { echo "ERROR: could not download $PKG RPM"; exit 1; }
createrepo_c "$LOCAL_REPO_DIR" &>/dev/null

# Remove any repo file that already points at this URL (idempotent re-run)
grep -rl "$REPO_URL" /etc/yum.repos.d/ 2>/dev/null | xargs -r rm -f
