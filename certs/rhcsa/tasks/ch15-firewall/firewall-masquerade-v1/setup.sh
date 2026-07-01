#!/usr/bin/env bash
dnf install -y firewalld &>/dev/null
systemctl enable --now firewalld
for _i in $(seq 15); do
  systemctl is-active --quiet firewalld && break
  sleep 1
done

firewall-cmd --permanent --zone="$ZONE" --remove-masquerade &>/dev/null || true
firewall-cmd --reload
