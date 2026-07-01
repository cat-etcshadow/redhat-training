#!/usr/bin/env bash
firewall-cmd --permanent --zone="$ZONE" --add-masquerade
firewall-cmd --reload
