#!/usr/bin/env bash
firewall-cmd --permanent --remove-service=ssh
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=192.168.100.0/24 service name=ssh accept'
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 service name=ssh reject'
firewall-cmd --reload
