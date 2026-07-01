#!/usr/bin/env bash
dnf config-manager --add-repo "$REPO_URL"

repo_file=$(grep -rl "$REPO_URL" /etc/yum.repos.d/ | head -1)
if grep -q '^gpgcheck=' "$repo_file"; then
  sed -i 's/^gpgcheck=.*/gpgcheck=0/' "$repo_file"
else
  sed -i '/^\[/a gpgcheck=0' "$repo_file"
fi

dnf install -y "$PKG"
