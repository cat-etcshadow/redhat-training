#!/usr/bin/env bash
dnf install -y vsftpd &>/dev/null
mkdir -p /srv/ftp/pub
echo 'Welcome to FTP' > /srv/ftp/pub/welcome.txt
# Directory inherits default_t or usr_t — wrong for vsftpd content
semanage fcontext -d '/srv/ftp/pub(/.*)?'   2>/dev/null || true
restorecon -Rv /srv/ftp/pub &>/dev/null
