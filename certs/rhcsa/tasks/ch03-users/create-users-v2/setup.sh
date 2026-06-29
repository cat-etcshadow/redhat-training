#!/usr/bin/env bash
userdel -r "$USER1" 2>/dev/null || true
userdel -r "$USER2" 2>/dev/null || true
groupdel "$GROUP"   2>/dev/null || true
