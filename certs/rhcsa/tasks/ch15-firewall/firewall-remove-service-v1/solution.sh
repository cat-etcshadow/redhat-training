#!/usr/bin/env bash
firewall-cmd --permanent --zone=public --remove-service="$SVC_NAME"
firewall-cmd --reload
