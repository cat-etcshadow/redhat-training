#!/usr/bin/env bash
SIZES=(100M 200M 300M 500M 50M)
is=$(( RANDOM % ${#SIZES[@]} ))
echo "MAX_USE=${SIZES[$is]}"
