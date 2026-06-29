#!/usr/bin/env bash
USERS=(jsmith rsmith mlopez kchang apeters nwolf)
GROUPS1=(admins support devteam netops dbteam)
GROUPS2=(audit backup monitoring logging)
PRIMARY=(staff workers crew)

iu=$(( RANDOM % ${#USERS[@]} ))
ig1=$(( RANDOM % ${#GROUPS1[@]} ))
ig2=$(( RANDOM % ${#GROUPS2[@]} ))
ip=$(( RANDOM % ${#PRIMARY[@]} ))

echo "TARGET_USER=${USERS[$iu]}"
echo "SUPP_GROUP1=${GROUPS1[$ig1]}"
echo "SUPP_GROUP2=${GROUPS2[$ig2]}"
echo "NEW_PRIMARY=${PRIMARY[$ip]}"
