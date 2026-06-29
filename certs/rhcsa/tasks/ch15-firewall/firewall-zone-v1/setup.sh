#!/usr/bin/env bash
dnf install -y firewalld &>/dev/null
systemctl enable --now firewalld
# not immediately active after dnf install
for _i in $(seq 15); do
  systemctl is-active --quiet firewalld && break
  sleep 1
done
# remove zone if a prior session left it
firewall-cmd --permanent --delete-zone="$ZONE_NAME" 2>/dev/null || true
firewall-cmd --reload 2>/dev/null || true
