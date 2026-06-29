#!/usr/bin/env bash
# Reset to volatile (default) storage
sed -i '/^Storage/d; /^SystemMaxUse/d' /etc/systemd/journald.conf
rm -rf /var/log/journal
systemctl restart systemd-journald
