#!/usr/bin/env bash
semanage fcontext -a -t httpd_sys_content_t '/var/www/html/secure(/.*)?'
restorecon -Rv /var/www/html/secure
