#!/usr/bin/env bash
groupadd "$SUPP_GROUP1" 2>/dev/null || true
groupadd "$SUPP_GROUP2" 2>/dev/null || true
groupadd "$NEW_PRIMARY"  2>/dev/null || true
usermod -g "$NEW_PRIMARY" "$TARGET_USER"
usermod -aG "${SUPP_GROUP1},${SUPP_GROUP2}" "$TARGET_USER"
