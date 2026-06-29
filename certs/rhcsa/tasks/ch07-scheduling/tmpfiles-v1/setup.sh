#!/usr/bin/env bash
id myapp &>/dev/null || useradd -r -M -s /sbin/nologin myapp
rm -f /etc/tmpfiles.d/myapp.conf
rm -rf /run/myapp
