#!/usr/bin/env bash
GROUP_NAMES=(release-team qa-team ops-team infra-team)
USERS=(nadia oscar priya quinn riley sofia tariq umar)

ig=$(( RANDOM % ${#GROUP_NAMES[@]} ))
shuf_users=($(printf '%s\n' "${USERS[@]}" | shuf))

echo "TARGET_GROUP=${GROUP_NAMES[$ig]}"
echo "OLD_MEMBER=${shuf_users[0]}"
echo "NEW_MEMBER1=${shuf_users[1]}"
echo "NEW_MEMBER2=${shuf_users[2]}"
echo "NEW_MEMBER3=${shuf_users[3]}"
