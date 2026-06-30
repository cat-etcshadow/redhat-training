#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Configure static network interface
  hosts: dev
  become: true
  tasks:
    - name: Configure static IP on $DEVICE
      community.general.nmcli:
        conn_name: $CONN_NAME
        ifname: $DEVICE
        type: ethernet
        ip4: $IP_ADDRESS
        gw4: $GATEWAY
        dns4:
          - $DNS_SERVER
        method4: manual
        state: present
EOF
chown student:student "$PLAYBOOK_FILE"
