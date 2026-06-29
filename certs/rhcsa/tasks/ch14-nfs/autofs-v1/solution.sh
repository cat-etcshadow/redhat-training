#!/usr/bin/env bash
dnf install -y autofs nfs-utils
cat > /etc/auto.master.d/homes.autofs <<'CONF'
/home/remotes  /etc/auto.homes
CONF
cat > /etc/auto.homes <<'CONF'
*  -rw,nfsvers=4  nfsserver.example.com:/exports/homes/&
CONF
systemctl enable --now autofs
