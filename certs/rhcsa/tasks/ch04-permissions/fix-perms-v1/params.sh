#!/usr/bin/env bash
WEBUSERS=(webmaster wwwadmin sitedev)
GROUPS=(webteam siteops devgroup)
idx=$(( RANDOM % ${#WEBUSERS[@]} ))
echo "WEB_USER=${WEBUSERS[$idx]}"
echo "WEB_GROUP=${GROUPS[$idx]}"
echo "WEB_ROOT=/var/www/rhtr_site"
