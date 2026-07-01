#!/usr/bin/env bash
dnf remove -y "$PKG" &>/dev/null || true
dnf install -y "$PKG" &>/dev/null
# Reclassify it as if it had been pulled in only as a dependency
dnf mark dependency "$PKG" &>/dev/null
