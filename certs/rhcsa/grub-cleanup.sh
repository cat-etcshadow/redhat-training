#!/usr/bin/env bash
# grub-cleanup.sh — purge boot loader entries left by a foreign machine-id
#
# Runs inside the RHCSA VM (via vm_exec_script) during topology_create, once
# per VM, before any task setups run. Idempotent.
#
# The Rocky cloud image ships with a kernel/BLS entry baked in under a
# build-time machine-id; systemd-firstboot then assigns this VM instance its
# own /etc/machine-id, and a newer, never-booted kernel ends up registered
# under that new ID while the actually-running kernel stays registered under
# the old, foreign one. From that point grubby's "DEFAULT" is ambiguous: it
# can silently point at a kernel entry nothing has touched, while a
# setup.sh that ran `grubby --update-kernel=DEFAULT` earlier in the same
# session modified the *other* one. Observed via
# certs/rhcsa/tasks/ch11-boot/grubby-remove-param-v1: its setup added a
# kernel param to DEFAULT, but by the time the candidate reached the task,
# `grubby --info=DEFAULT` showed a different, unmodified entry.
#
# Fix: keep only the loader entry (and matching rescue entry, if any) for
# the kernel that's actually running (`uname -r`), delete every other
# entry regardless of machine-id, and pin it as the explicit default. That
# leaves a single, unambiguous DEFAULT for the rest of the session — no
# ch11-boot task actually reboots the VM during grading, so nothing needs
# the extra, unbooted kernel entry.
set -uo pipefail

running=$(uname -r)
keep=""
keep_mid=""
for f in /boot/loader/entries/*.conf; do
  [[ -f "$f" ]] || continue
  if awk -v r="$running" '/^version /{if ($2==r) exit 0; exit 1}' "$f"; then
    keep="$f"
    keep_mid=$(basename "$f"); keep_mid=${keep_mid%%-*}
    break
  fi
done

if [[ -z "$keep" ]]; then
  echo "WARN: no loader entry matches running kernel $running — skipping grub cleanup" >&2
  exit 0
fi

removed=0
for f in /boot/loader/entries/*.conf; do
  [[ -f "$f" ]] || continue
  [[ "$f" == "$keep" ]] && continue
  base=$(basename "$f")
  # keep a same-machine-id rescue entry (real rescue-mode capability)
  [[ "$base" == "$keep_mid"-0-rescue.conf ]] && continue
  kpath=$(awk '/^linux /{print $2; exit}' "$f")
  [[ -n "$kpath" ]] && grubby --remove-kernel="$kpath" &>/dev/null
  (( removed++ ))
done

grubby --set-default="$(awk '/^linux /{print $2; exit}' "$keep")" &>/dev/null

if (( removed > 0 )); then
  echo "grub-cleanup: removed $removed stale loader entr$([[ $removed -eq 1 ]] && echo y || echo ies), pinned default to $running"
else
  echo "grub-cleanup: already clean"
fi
