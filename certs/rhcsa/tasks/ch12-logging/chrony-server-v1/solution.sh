#!/usr/bin/env bash
dnf install -y chrony
cat > /etc/chrony.conf <<'CONF'
pool pool.ntp.org iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
allow 192.168.0.0/24
logdir /var/log/chrony
CONF
systemctl enable --now chronyd
systemctl restart chronyd
