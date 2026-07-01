#!/usr/bin/env bash
PKGS=(figlet tree screen mtr)
i=$(( RANDOM % ${#PKGS[@]} ))

echo "PKG=${PKGS[$i]}"
echo "LOCAL_REPO_DIR=/opt/rhtr-cm-repo"
echo "REPO_URL=file:///opt/rhtr-cm-repo"
