#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

command -v flatpak &>/dev/null || fail "flatpak is not installed"

flatpak remotes --system 2>/dev/null | awk '{print $1}' | grep -qx "flathub" \
  || fail "flathub remote is not configured system-wide"

flatpak list --system --app 2>/dev/null | grep -q "org.gnome.gedit" \
  || fail "org.gnome.gedit is not installed"

flatpak list --system --app 2>/dev/null | grep -q "org.gnome.Calculator" \
  && fail "org.gnome.Calculator is still installed — it should have been removed"

[[ $errors -eq 0 ]] && exit 0 || exit 1
