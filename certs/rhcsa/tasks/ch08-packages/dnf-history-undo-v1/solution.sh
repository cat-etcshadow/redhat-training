#!/usr/bin/env bash
tid=$(dnf history list 2>/dev/null | grep -m1 -F "$PKG_A" | awk '{print $1}')
dnf history undo "$tid" -y &>/dev/null
