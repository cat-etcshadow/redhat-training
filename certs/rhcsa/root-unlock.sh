#!/usr/bin/env bash
# root-unlock.sh — give root a known, unlocked password so sulogin-gated
# rescue/emergency targets are actually reachable
#
# Runs inside the RHCSA VM (via vm_exec_script) during topology_create, once
# per VM, before any task setups run. Idempotent.
#
# The Rocky cloud image ships root LOCKED by default (shadow hash prefixed
# with "!") — standard cloud-init hardening: no root login, only a sudo
# user with SSH keys. rd.break doesn't care (it drops straight into a root
# shell in the initramfs, no login prompt), but `systemctl isolate
# rescue.target` / the automatic emergency-mode drop from a bad fstab entry
# both go through sulogin on the real console, and sulogin refuses to hand
# out a shell to anyone — console included — while root is locked
# ("Cannot open access to console, the root account is locked"). That
# makes isolate-target-v1 and repair-fstab-v1 unreachable as shipped.
#
# Fix: unlock root with a known password up front. reset-root-password-v1's
# own setup.sh runs after this (per-task setups run after topology_create)
# and freely re-obscures it for that one task without conflict.
set -uo pipefail

ROOT_PASSWORD='RedHat123!'

if [[ "$(passwd -S root | awk '{print $2}')" == "L" ]] || ! getent shadow root | cut -d: -f2 | grep -q '^\$'; then
  echo "root:${ROOT_PASSWORD}" | chpasswd
  echo "root-unlock: root password set and account unlocked"
else
  echo "root-unlock: root already unlocked with a set password — leaving as-is"
fi
