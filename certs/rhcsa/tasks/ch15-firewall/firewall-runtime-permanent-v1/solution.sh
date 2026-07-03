#!/usr/bin/env bash
firewall-cmd --permanent --zone=public --add-service=smtp
firewall-cmd --reload
firewall-cmd --zone=public --add-service=ftp
