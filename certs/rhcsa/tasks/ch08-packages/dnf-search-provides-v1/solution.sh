#!/usr/bin/env bash
dnf provides "$BIN_PATH" &>/dev/null
dnf install -y "$PKG"
