#!/usr/bin/env bash
USERS1=(anna clara priya sonia kira)
USERS2=(mark leon raj victor)
MIN_AGES=(1 2 3 5)
MAX_AGES1=(30 45 60 90)
WARN_DAYS=(5 7 10 14)
INACTIVES=(3 5 7 14)
MAX_AGES2=(60 90 120 180)

i1=$(( RANDOM % ${#USERS1[@]} ))
i2=$(( RANDOM % ${#USERS2[@]} ))
im=$(( RANDOM % ${#MIN_AGES[@]} ))
ix=$(( RANDOM % ${#MAX_AGES1[@]} ))
iw=$(( RANDOM % ${#WARN_DAYS[@]} ))
ii=$(( RANDOM % ${#INACTIVES[@]} ))
iy=$(( RANDOM % ${#MAX_AGES2[@]} ))

echo "USER1=${USERS1[$i1]}"
echo "USER2=${USERS2[$i2]}"
echo "MIN_AGE=${MIN_AGES[$im]}"
echo "MAX_AGE1=${MAX_AGES1[$ix]}"
echo "WARN_DAYS=${WARN_DAYS[$iw]}"
echo "INACTIVE=${INACTIVES[$ii]}"
echo "MAX_AGE2=${MAX_AGES2[$iy]}"
