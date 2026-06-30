#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Archive SSH config and fetch to control node
  hosts: dev
  become: true
  tasks:
    - name: Create archive of /etc/ssh on remote hosts
      ansible.builtin.archive:
        path: /etc/ssh/
        dest: /tmp/$ARCHIVE_NAME
        format: gz

    - name: Fetch archive to control node
      ansible.builtin.fetch:
        src: /tmp/$ARCHIVE_NAME
        dest: $FETCH_DEST/{{ inventory_hostname }}/
        flat: false
EOF

chown student:student "$PLAYBOOK_FILE"
