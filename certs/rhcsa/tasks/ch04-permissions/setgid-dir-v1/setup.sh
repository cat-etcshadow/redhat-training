#!/usr/bin/env bash
groupdel webteam 2>/dev/null || true
userdel -r webdev 2>/dev/null || true
rm -rf /srv/webshared
