#!/usr/bin/env bash
PREFIXES=(2001:db8:1 2001:db8:2 2001:db8:a 2001:db8:b fd00:1 fd00:2)
HOSTS=(10 20 30 40 50 60)
PREFIXLENS=(64 64 64 64 48 48)
idx=$(( RANDOM % ${#PREFIXES[@]} ))
echo "IPV6_ADDR=${PREFIXES[$idx]}::${HOSTS[$idx]}"
echo "IPV6_PREFIX=${PREFIXLENS[$idx]}"
echo "IPV6_GW=${PREFIXES[$idx]}::1"
