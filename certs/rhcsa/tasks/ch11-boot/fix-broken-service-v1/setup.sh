#!/usr/bin/env bash
cat > /usr/local/bin/rhtr-brokensvc.sh << 'SCRIPT'
#!/bin/bash
echo "$(date): rhtr-brokensvc ran" >> /var/log/rhtr-brokensvc.log
SCRIPT
chmod +x /usr/local/bin/rhtr-brokensvc.sh
rm -f /var/log/rhtr-brokensvc.log

systemctl stop rhtr-brokensvc.service 2>/dev/null || true
cat > /etc/systemd/system/rhtr-brokensvc.service << 'EOF2'
[Unit]
Description=RHTR Demo Service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/rhtr-brokensvc-typo.sh

[Install]
WantedBy=multi-user.target
EOF2

systemctl daemon-reload
systemctl enable rhtr-brokensvc.service &>/dev/null
systemctl start rhtr-brokensvc.service 2>/dev/null || true
