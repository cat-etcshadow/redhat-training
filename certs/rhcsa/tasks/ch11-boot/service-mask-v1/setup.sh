#!/usr/bin/env bash
systemctl unmask "${UNIT_NAME}.service" 2>/dev/null || true
systemctl stop "${UNIT_NAME}.service" 2>/dev/null || true
systemctl disable "${UNIT_NAME}.service" 2>/dev/null || true

cat > "/etc/systemd/system/${UNIT_NAME}.service" << SERVICE
[Unit]
Description=RHTR ${UNIT_NAME} service (deprecated)

[Service]
ExecStart=/usr/bin/sleep infinity

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
