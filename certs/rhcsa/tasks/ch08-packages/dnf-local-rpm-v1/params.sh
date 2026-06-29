#!/usr/bin/env bash
# use simple packages that are always available in RHEL/Rocky repos
PKGS=(tree words dos2unix bc)
idx=$(( RANDOM % ${#PKGS[@]} ))
echo "LOCAL_PKG=${PKGS[$idx]}"
echo "LOCAL_RPM_DIR=/opt/rhtr_localrpm"
echo "LOCAL_REPO_DIR=/opt/rhtr_localrepo"
