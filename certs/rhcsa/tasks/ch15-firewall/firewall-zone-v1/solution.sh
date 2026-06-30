#!/usr/bin/env bash
firewall-cmd --permanent --new-zone="$ZONE_NAME"
firewall-cmd --permanent --zone="$ZONE_NAME" --add-source="$ZONE_SOURCE"
firewall-cmd --permanent --zone="$ZONE_NAME" --add-service="$ZONE_SVC1"
firewall-cmd --permanent --zone="$ZONE_NAME" --add-service="$ZONE_SVC2"
firewall-cmd --reload
