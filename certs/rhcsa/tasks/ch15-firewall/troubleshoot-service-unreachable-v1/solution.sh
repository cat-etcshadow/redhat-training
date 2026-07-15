#!/usr/bin/env bash
# investigate:
# ss -tlnp | grep 8080
# firewall-cmd --list-all
firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload
