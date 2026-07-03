#!/usr/bin/env bash
DOMAINS=(corp.example.com internal.example.org lab.example.net)
i=$(( RANDOM % ${#DOMAINS[@]} ))
echo "SEARCH_DOMAIN=${DOMAINS[$i]}"
