#!/usr/bin/env bash
sestatus > "$OUTPUT_FILE"
setenforce 0
getenforce
setenforce 1
getenforce
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
ls -Z /etc/passwd >> "$OUTPUT_FILE"
ls -Z /usr/sbin/sshd >> "$OUTPUT_FILE"
