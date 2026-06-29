#!/usr/bin/env bash
firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --permanent --add-port=5060-5070/udp
firewall-cmd --reload
