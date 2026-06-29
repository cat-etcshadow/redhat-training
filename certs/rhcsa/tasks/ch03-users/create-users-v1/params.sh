#!/usr/bin/env bash
USERS1=(alice maya leon petra sam dana kai)
USERS2=(bob dave carlos james nina felix morgan)
GROUPS=(sysmgrs sysops netadmin devops dbadmin svcteam)
GIDS=(50000 50001 50010 55000 60000 65000)
U1_BASE=(2001 2010 2020 2030 2050 2060)

i1=$(( RANDOM % ${#USERS1[@]} ))
i2=$(( RANDOM % ${#USERS2[@]} ))
ig=$(( RANDOM % ${#GROUPS[@]} ))
id=$(( RANDOM % ${#GIDS[@]} ))
iu=$(( RANDOM % ${#U1_BASE[@]} ))

echo "USER1=${USERS1[$i1]}"
echo "USER2=${USERS2[$i2]}"
echo "GROUP=${GROUPS[$ig]}"
echo "GID=${GIDS[$id]}"
echo "UID1=${U1_BASE[$iu]}"
echo "UID2=$(( ${U1_BASE[$iu]} + 1 ))"
echo "PASSWORD=RedHat9!"
