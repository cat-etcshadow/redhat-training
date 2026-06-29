#!/usr/bin/env bash
USERS1=(carol maya petra sam dana zara)
USERS2=(dave carlos james felix morgan ren)
GROUPS=(developers analysts operators webteam dbteam svcgroup)
GIDS=(50001 50002 50020 55001 61000 65001)
U1_BASE=(2003 2011 2021 2031 2051 2061)
MAX_AGES=(30 45 60 90)
WARN_DAYS=(5 7 10 14)
INACTIVES=(3 5 7 14)

ig=$(( RANDOM % ${#GROUPS[@]} ))
id=$(( RANDOM % ${#GIDS[@]} ))
iu=$(( RANDOM % ${#U1_BASE[@]} ))
im=$(( RANDOM % ${#MAX_AGES[@]} ))
iw=$(( RANDOM % ${#WARN_DAYS[@]} ))
ii=$(( RANDOM % ${#INACTIVES[@]} ))

# pick two distinct users
i1=$(( RANDOM % ${#USERS1[@]} ))
i2=$(( RANDOM % ${#USERS2[@]} ))

echo "USER1=${USERS1[$i1]}"
echo "USER2=${USERS2[$i2]}"
echo "GROUP=${GROUPS[$ig]}"
echo "GID=${GIDS[$id]}"
echo "UID1=${U1_BASE[$iu]}"
echo "UID2=$(( ${U1_BASE[$iu]} + 1 ))"
echo "MAX_AGE=${MAX_AGES[$im]}"
echo "WARN_DAYS=${WARN_DAYS[$iw]}"
echo "INACTIVE=${INACTIVES[$ii]}"
echo "PASSWORD=RedHat9!"
