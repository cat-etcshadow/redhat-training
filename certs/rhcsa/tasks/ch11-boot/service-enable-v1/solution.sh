#!/usr/bin/env bash
dnf install -y postfix
systemctl enable --now postfix
