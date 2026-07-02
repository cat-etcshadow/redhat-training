#!/usr/bin/env bash
# Rocky already ships a real "extras" repo, enabled by default. Disable it
# here so the task starts in the expected state. A separate repo file with
# its own [extras] id would collide with this one and break dnf entirely.
repo_file=$(grep -l '^\[extras\]' /etc/yum.repos.d/*.repo | head -1)
sed -i '/^\[extras\]/,/^\[/{s/^enabled=1/enabled=0/}' "$repo_file"
dnf remove -y epel-release 2>/dev/null || true
