#!/usr/bin/env bash
# Create a disabled extras repo pointing at the OS BaseOS repo as a stand-in
# This avoids needing internet access during setup
cat > /etc/yum.repos.d/rhtr-extras.repo <<'REPO'
[extras]
name=RHTR Extras (disabled by default)
baseurl=file:///mnt/BaseOS
enabled=0
gpgcheck=0
REPO
dnf remove -y epel-release 2>/dev/null || true
