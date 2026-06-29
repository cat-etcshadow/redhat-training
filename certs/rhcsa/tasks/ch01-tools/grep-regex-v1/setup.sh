#!/usr/bin/env bash
rm -rf "$LOG_DIR"
mkdir -p "$LOG_DIR/app" "$LOG_DIR/sys"

cat > "$LOG_DIR/app/app.log" <<'EOF'
2024-01-10 08:00:01 INFO  service started on 192.168.1.10
2024-01-10 08:01:15 ERROR failed to connect to 10.0.0.5
2024-01-10 08:01:16 WARN  retry 1 of 3
2024-01-10 08:01:20 ERROR timeout from host 172.16.0.1
2024-01-10 08:02:00 INFO  connected to 192.168.1.10
EOF

cat > "$LOG_DIR/app/access.log" <<'EOF'
GET / 200 from 192.168.1.50
POST /api 500 from 10.10.0.1
GET /health 200 from 127.0.0.1
DELETE /resource 403 from 192.168.0.99
EOF

cat > "$LOG_DIR/sys/messages" <<'EOF'
kernel: eth0 link up 1000Mbps
sshd: Accepted password for root from 203.0.113.5 port 22
error: disk /dev/sdb read failure
kernel: out of memory: kill process 1234
EOF

rm -f "$ERROR_OUTPUT" "$IP_OUTPUT"
