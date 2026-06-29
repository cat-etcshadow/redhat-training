#!/usr/bin/env bash
# Investigate:
# ausearch -m avc -ts recent | grep httpd
# sealert -a /var/log/audit/audit.log
setsebool -P httpd_enable_cgi on
