#!/usr/bin/env bash
PKGS=(figlet tree screen mtr)
i=$(( RANDOM % ${#PKGS[@]} ))
echo "PKG=${PKGS[$i]}"
