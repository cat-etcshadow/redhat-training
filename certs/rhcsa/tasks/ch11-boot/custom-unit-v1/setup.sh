#!/usr/bin/env bash
cat > "/usr/local/bin/${UNIT_SCRIPT}" << 'SCRIPT'
#!/bin/bash
echo "$(date): service ran" >> /var/log/rhtr-unit.log
SCRIPT
chmod +x "/usr/local/bin/${UNIT_SCRIPT}"

systemctl stop "${UNIT_NAME}.service" 2>/dev/null || true
systemctl disable "${UNIT_NAME}.service" 2>/dev/null || true
rm -f "/etc/systemd/system/${UNIT_NAME}.service"
systemctl daemon-reload
