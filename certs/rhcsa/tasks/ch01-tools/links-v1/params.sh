#!/usr/bin/env bash
BASES=(app config data service tool)
idx=$(( RANDOM % ${#BASES[@]} ))
BASE=${BASES[$idx]}

echo "TARGET_FILE=/opt/rhtr_links/source_${BASE}.txt"
echo "HARD_LINK=/opt/rhtr_links/hardlink_${BASE}.txt"
echo "SOFT_LINK=/opt/rhtr_links/symlink_${BASE}.txt"
echo "SOFT_TARGET=/opt/rhtr_links/source_${BASE}.txt"
