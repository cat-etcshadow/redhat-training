#!/usr/bin/env bash
# remove any existing working dir so student starts fresh
rm -rf "$ANSIBLE_DIR"
mkdir -p "$ANSIBLE_DIR"
chown student:student "$ANSIBLE_DIR"
