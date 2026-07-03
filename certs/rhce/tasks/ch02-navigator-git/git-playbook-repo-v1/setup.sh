#!/usr/bin/env bash
dnf install -y git &>/dev/null || true
mkdir -p /srv/git
rm -rf "$BARE_REPO" "$CLONE_DIR"

git init --bare "$BARE_REPO" &>/dev/null

tmp=$(mktemp -d)
git -C "$tmp" init -q -b main
git -C "$tmp" config user.email "admin@example.com"
git -C "$tmp" config user.name "Admin"
echo "# Ansible Playbooks" > "$tmp/README.md"
git -C "$tmp" add README.md
git -C "$tmp" commit -q -m "Initial commit"
git -C "$tmp" remote add origin "$BARE_REPO"
git -C "$tmp" push -q origin main
rm -rf "$tmp"

chown -R student:student /srv/git
