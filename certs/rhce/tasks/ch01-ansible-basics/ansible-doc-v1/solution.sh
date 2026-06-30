#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Insert block of text into file
  hosts: all
  become: true
  tasks:
    - name: Insert block into $TARGET_FILE
      ansible.builtin.blockinfile:
        path: $TARGET_FILE
        block: "$BLOCK_CONTENT"
        marker: "# $MARKER {mark}"
        create: true
        state: present
EOF
chown student:student "$PLAYBOOK_FILE"
