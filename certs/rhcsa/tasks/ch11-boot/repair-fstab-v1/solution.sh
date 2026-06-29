#!/usr/bin/env bash
sed -i '/dead-beef-0000-0000-bad-fstab/d' /etc/fstab
mount -a
