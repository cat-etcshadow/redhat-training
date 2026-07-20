#!/usr/bin/env bash
mkdir -p /srv/rhtr-app
echo "ok" > /srv/rhtr-app/index.html
pkill -f "http.server 8080" 2>/dev/null || true
sleep 1
cd /srv/rhtr-app && nohup python3 -m http.server 8080 </dev/null &>/dev/null &
disown

firewall-cmd --permanent --zone=public --remove-port=8080/tcp &>/dev/null || true
firewall-cmd --reload &>/dev/null
