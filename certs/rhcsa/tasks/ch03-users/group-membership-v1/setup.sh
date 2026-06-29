#!/usr/bin/env bash
userdel -r "$TARGET_USER" 2>/dev/null || true
groupdel "$SUPP_GROUP1"  2>/dev/null || true
groupdel "$SUPP_GROUP2"  2>/dev/null || true
groupdel "$NEW_PRIMARY"  2>/dev/null || true
useradd "$TARGET_USER"
