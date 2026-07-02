#!/usr/bin/env bash
PKGS=(tmux tree bc mtr)
i=$(( RANDOM % ${#PKGS[@]} ))
echo "PKG=${PKGS[$i]}"
