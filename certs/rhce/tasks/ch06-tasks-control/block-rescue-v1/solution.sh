#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Deploy httpd with error handling
  hosts: dev:test:prod
  become: true
  tasks:
    - name: httpd deployment block
      block:
        - name: Install httpd
          ansible.builtin.dnf:
            name: httpd
            state: present

        - name: Start httpd service
          ansible.builtin.service:
            name: httpd
            state: started

      rescue:
        - name: Report httpd failure
          ansible.builtin.debug:
            msg: "httpd setup failed"

      always:
        - name: Record deployment attempt
          ansible.builtin.copy:
            content: "attempted"
            dest: /tmp/deploy_status.txt
EOF

chown student:student "$PLAYBOOK_FILE"
