#!/usr/bin/env bash
NETS=(192.168.100.0/24 10.10.0.0/16 172.16.5.0/24 10.20.30.0/24 192.168.200.0/24)
GWS=(192.168.1.254 10.0.0.1 172.16.1.1 10.0.1.1 192.168.1.1)

in=$(( RANDOM % ${#NETS[@]} ))
ig=$(( RANDOM % ${#GWS[@]} ))

echo "STATIC_NET=${NETS[$in]}"
echo "STATIC_GW=${GWS[$ig]}"
