#!/usr/bin/env bash
# Reset journald.conf to defaults by removing any Storage/SystemMaxUse lines
sed -i '/^Storage=/d; /^SystemMaxUse=/d' /etc/systemd/journald.conf
systemctl restart systemd-journald
