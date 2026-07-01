#!/usr/bin/env bash
userdel -r "$LOCK_USER"   2>/dev/null || true
userdel -r "$UNLOCK_USER" 2>/dev/null || true

useradd -m "$LOCK_USER"
echo "${LOCK_USER}:RedHat9!" | chpasswd

useradd -m "$UNLOCK_USER"
echo "${UNLOCK_USER}:RedHat9!" | chpasswd
usermod -L "$UNLOCK_USER"
