#!/usr/bin/env bash
sed -i '/^Storage=/d; /^SystemMaxUse=/d' /etc/systemd/journald.conf
printf 'Storage=persistent\nSystemMaxUse=%s\n' "$MAX_USE" >> /etc/systemd/journald.conf
mkdir -p /var/log/journal
systemctl restart systemd-journald
