#!/usr/bin/env bash
dnf install -y httpd &>/dev/null
# Ensure boolean is off
setsebool -P httpd_can_network_connect off
