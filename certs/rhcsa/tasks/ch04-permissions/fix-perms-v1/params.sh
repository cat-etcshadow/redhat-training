#!/usr/bin/env bash
WEBUSERS=(webmaster wwwadmin sitedev)
GROUP_NAMES=(webteam siteops devgroup)
idx=$(( RANDOM % ${#WEBUSERS[@]} ))
echo "WEB_USER=${WEBUSERS[$idx]}"
echo "WEB_GROUP=${GROUP_NAMES[$idx]}"
echo "WEB_ROOT=/var/www/rhtr_site"
