#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR/host_vars"

cat > "$ANSIBLE_DIR/host_vars/node1.yml" <<'EOF'
http_port: 8080
EOF

cat > "$ANSIBLE_DIR/host_vars/node2.yml" <<'EOF'
http_port: 9090
EOF

cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Print http_port per host
  hosts: dev:test
  gather_facts: false
  tasks:
    - name: Show http_port for each host
      ansible.builtin.debug:
        msg: "{{ inventory_hostname }} is using http_port {{ http_port }}"
EOF

chown -R student:student "$ANSIBLE_DIR"
