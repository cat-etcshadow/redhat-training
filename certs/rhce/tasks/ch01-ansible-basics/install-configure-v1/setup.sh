#!/usr/bin/env bash
# Only reset this task's own targets, not the whole ANSIBLE_DIR — every
# sibling ch01 task shares that directory and plants its own baseline
# ansible.cfg/inventory there too (same convention: mkdir -p + rm -f own
# targets). A full `rm -rf $ANSIBLE_DIR` here used to wipe those out or leave
# CFG_FILE/INVENTORY_FILE missing depending on setup-script draw order,
# contradicting ansible-cfg-advanced-v1's requirement that the base config
# be preserved.
mkdir -p "$ANSIBLE_DIR"
rm -f "$CFG_FILE" "$INVENTORY_FILE"
chown -R student:student "$ANSIBLE_DIR"
