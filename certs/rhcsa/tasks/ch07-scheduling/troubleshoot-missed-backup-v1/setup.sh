#!/usr/bin/env bash
id backupsvc &>/dev/null || useradd -r -m -d /var/lib/backupsvc -s /sbin/nologin backupsvc
mkdir -p /var/backups/app-data
chown backupsvc:backupsvc /var/backups/app-data

cat > /usr/local/bin/rhtr-backup.sh <<'EOF'
#!/usr/bin/env bash
tar -czf "/var/backups/app-data/backup-$(date +%Y%m%d%H%M%S).tar.gz" /etc/hostname
EOF
chmod 755 /usr/local/bin/rhtr-backup.sh

# deliberately disabled cron entry (commented out)
cat > /etc/cron.d/rhtr-backup <<'EOF'
# 30 2 * * * backupsvc /usr/local/bin/rhtr-backup.sh
EOF
chmod 644 /etc/cron.d/rhtr-backup
rm -f /var/backups/app-data/backup-*.tar.gz
systemctl restart crond 2>/dev/null || true
