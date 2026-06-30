#!/usr/bin/env bash
cat > "/etc/systemd/system/${UNIT_NAME}.service" << EOF
[Unit]
Description=${UNIT_DESC}

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/${UNIT_SCRIPT}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now "${UNIT_NAME}.service"
