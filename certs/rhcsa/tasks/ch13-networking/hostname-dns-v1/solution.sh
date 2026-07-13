#!/usr/bin/env bash
hostnamectl set-hostname "$FQDN"
echo "$IP_ADDR  $FQDN  $SHORTNAME" >> /etc/hosts
