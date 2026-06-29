#!/usr/bin/env bash
dnf install -y acl >/dev/null
id auditor &>/dev/null     || useradd -M auditor
getent group contractors &>/dev/null || groupadd contractors
mkdir -p /var/data/reports
chown root:root /var/data/reports
chmod 755 /var/data/reports
# Clear any existing ACLs
setfacl -b /var/data/reports
