#!/usr/bin/env bash
dnf install -y chrony &>/dev/null
systemctl enable --now chronyd
# Reset chrony.conf to a basic state
cat > /etc/chrony.conf <<'CONF'
pool 2.rhel.pool.ntp.org iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
logdir /var/log/chrony
CONF
systemctl restart chronyd
