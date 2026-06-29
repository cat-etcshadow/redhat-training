#!/usr/bin/env bash
dnf install -y rsyslog
systemctl enable --now rsyslog
cat > /etc/rsyslog.d/auth-errors.conf <<'CONF'
auth.crit    /var/log/auth-critical.log
CONF
systemctl restart rsyslog
logger -p auth.crit "Test critical auth message"
