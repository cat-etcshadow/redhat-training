#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Configure time synchronisation
  hosts: all
  become: true
  vars:
    timesync_ntp_servers:
      - hostname: $NTP_SERVER
        iburst: yes
  roles:
    - rhel_system_roles.timesync
EOF
chown student:student "$PLAYBOOK_FILE"
