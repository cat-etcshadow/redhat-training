#!/usr/bin/env bash
systemctl unmask "${UNIT_NAME}.service" 2>/dev/null || true

cat > "/etc/systemd/system/${UNIT_NAME}.service" << SERVICE
[Unit]
Description=RHTR ${UNIT_NAME} service

[Service]
ExecStart=/usr/bin/sleep infinity

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now "${UNIT_NAME}.service"
