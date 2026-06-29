#!/usr/bin/env bash
groupadd webteam
useradd -G webteam webdev
mkdir -p /srv/webshared
chown root:webteam /srv/webshared
chmod 2770 /srv/webshared
