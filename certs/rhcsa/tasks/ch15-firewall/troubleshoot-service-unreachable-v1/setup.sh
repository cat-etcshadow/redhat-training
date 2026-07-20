#!/usr/bin/env bash
mkdir -p /srv/rhtr-app
echo "ok" > /srv/rhtr-app/index.html
pkill -f "http.server 8080" 2>/dev/null || true
sleep 1
cd /srv/rhtr-app && nohup python3 -m http.server 8080 </dev/null &>/dev/null &
disown

dnf install -y firewalld &>/dev/null
systemctl enable --now firewalld
# not immediately active after dnf install
for _i in $(seq 15); do
  firewall-cmd --state &>/dev/null && break
  sleep 1
done
firewall-cmd --permanent --zone=public --remove-port=8080/tcp &>/dev/null || true
firewall-cmd --reload &>/dev/null
