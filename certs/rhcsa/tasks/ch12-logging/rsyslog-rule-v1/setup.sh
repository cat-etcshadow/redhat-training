#!/usr/bin/env bash
dnf install -y rsyslog &>/dev/null
systemctl enable --now rsyslog
rm -f "$CONF_FILE" "$LOG_FILE"
systemctl restart rsyslog
