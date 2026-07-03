#!/usr/bin/env bash
sed -i '/^\[Journal\]/,/^\[/{/^Storage/d}' /etc/systemd/journald.conf
grep -q '^\[Journal\]' /etc/systemd/journald.conf \
  || echo '[Journal]' >> /etc/systemd/journald.conf
sed -i '/^\[Journal\]/a Storage=persistent' /etc/systemd/journald.conf
mkdir -p /var/log/journal
systemctl restart systemd-journald

# Generate enough bulk journal content that vacuuming is a real, measurable action
head -c 10M /dev/urandom | base64 -w0 | fold -w 40000 | systemd-cat -t rhtr-vacuum-filler
sleep 1
journalctl --sync 2>/dev/null || true
