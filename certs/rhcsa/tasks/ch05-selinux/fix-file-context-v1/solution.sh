#!/usr/bin/env bash
semanage fcontext -a -t httpd_sys_content_t "/var/www/html/$WEBDIR(/.*)?"
restorecon -Rv "/var/www/html/$WEBDIR"
