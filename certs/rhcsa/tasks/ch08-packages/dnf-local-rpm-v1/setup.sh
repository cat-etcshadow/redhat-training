#!/usr/bin/env bash
# remove any prior install
dnf remove -y "$LOCAL_PKG" 2>/dev/null || true
rm -rf "$LOCAL_RPM_DIR" "$LOCAL_REPO_DIR"
rm -f /etc/yum.repos.d/rhtr-local.repo
mkdir -p "$LOCAL_RPM_DIR" "$LOCAL_REPO_DIR"
# download the RPM to simulate a locally available file
dnf download --destdir "$LOCAL_RPM_DIR" "$LOCAL_PKG" &>/dev/null \
  || { echo "ERROR: could not download $LOCAL_PKG RPM"; exit 1; }
# copy the same RPM into the local repo dir for part 2
cp "${LOCAL_RPM_DIR}"/*.rpm "$LOCAL_REPO_DIR/"
