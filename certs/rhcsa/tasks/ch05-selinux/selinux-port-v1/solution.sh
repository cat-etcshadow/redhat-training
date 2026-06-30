#!/usr/bin/env bash
dnf install -y httpd policycoreutils-python-utils &>/dev/null
semanage port -a -t http_port_t -p tcp "$HTTP_PORT"
sed -i "s/^Listen .*/Listen $HTTP_PORT/" /etc/httpd/conf/httpd.conf
systemctl enable --now httpd
