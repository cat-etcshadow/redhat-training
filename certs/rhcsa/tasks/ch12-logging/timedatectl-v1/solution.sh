#!/usr/bin/env bash
timedatectl set-timezone "$TIMEZONE"
systemctl enable --now chronyd
