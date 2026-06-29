#!/usr/bin/env bash
sed -i '/^\[Journal\]/,/^\[/{/^Storage/d; /^SystemMaxUse/d}' /etc/systemd/journald.conf
# Ensure [Journal] section has the entries
grep -q '^\[Journal\]' /etc/systemd/journald.conf \
  || echo '[Journal]' >> /etc/systemd/journald.conf
echo -e 'Storage=persistent\nSystemMaxUse=100M' >> /etc/systemd/journald.conf
mkdir -p /var/log/journal
systemctl restart systemd-journald
