#!/usr/bin/env bash
dnf install -y rsyslog
systemctl enable --now rsyslog
cat > "$CONF_FILE" <<CONF
$FACILITY.$SEVERITY    $LOG_FILE
CONF
systemctl restart rsyslog
logger -p "$FACILITY.$SEVERITY" "Test message"
