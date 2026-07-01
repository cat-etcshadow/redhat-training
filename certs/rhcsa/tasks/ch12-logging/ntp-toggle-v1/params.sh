#!/usr/bin/env bash
ACTIONS=(disable enable)
i=$(( RANDOM % 2 ))
echo "ACTION=${ACTIONS[$i]}"
