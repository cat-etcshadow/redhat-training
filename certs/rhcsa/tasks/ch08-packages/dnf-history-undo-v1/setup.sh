#!/usr/bin/env bash
dnf remove -y "$PKG_A" "$PKG_B" &>/dev/null || true
# Install both packages together in a single transaction — the "mistaken" install
dnf install -y "$PKG_A" "$PKG_B" &>/dev/null
