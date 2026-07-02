#!/usr/bin/env bash
PKGS=(tmux tree bc mtr)
i=$(( RANDOM % ${#PKGS[@]} ))

echo "PKG=${PKGS[$i]}"
echo "LOCAL_REPO_DIR=/opt/rhtr-cm-repo"
echo "REPO_URL=file:///opt/rhtr-cm-repo"
