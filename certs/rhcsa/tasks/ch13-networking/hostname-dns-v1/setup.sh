#!/usr/bin/env bash
hostnamectl set-hostname server.localdomain
# Remove any existing entry for the target hostname
sed -i "/${SHORTNAME}/d" /etc/hosts
