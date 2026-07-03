#!/usr/bin/env bash
dnf install -y vsftpd &>/dev/null
# Ensure boolean is off
setsebool -P ftpd_anon_write off
