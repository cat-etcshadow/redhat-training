#!/usr/bin/env bash
dnf install -y httpd policycoreutils-python-utils &>/dev/null
systemctl stop httpd 2>/dev/null || true
# Remove port if previously added (idempotent cleanup)
semanage port -d -t http_port_t -p tcp "$HTTP_PORT" 2>/dev/null || true
# Reset Listen to default 80
sed -i "s/^Listen .*/Listen 80/" /etc/httpd/conf/httpd.conf
systemctl disable --now httpd 2>/dev/null || true
