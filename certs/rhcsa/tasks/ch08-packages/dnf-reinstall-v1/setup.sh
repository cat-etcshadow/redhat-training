#!/usr/bin/env bash
dnf install -y httpd &>/dev/null
grep -q "corrupted by accident" /etc/httpd/conf/httpd.conf 2>/dev/null \
  || echo "# corrupted by accident" >> /etc/httpd/conf/httpd.conf
