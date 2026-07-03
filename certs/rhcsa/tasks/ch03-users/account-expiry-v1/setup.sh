#!/usr/bin/env bash
userdel -r "$CONTRACT_USER" 2>/dev/null || true
useradd "$CONTRACT_USER"
echo 'RedHat9!' | passwd --stdin "$CONTRACT_USER" &>/dev/null
