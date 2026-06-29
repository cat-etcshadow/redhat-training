#!/usr/bin/env bash
id myapp &>/dev/null || useradd -r -M -s /sbin/nologin myapp
cat > /etc/tmpfiles.d/myapp.conf <<'CONF'
d /run/myapp 0750 myapp myapp 10d
CONF
systemd-tmpfiles --create /etc/tmpfiles.d/myapp.conf
