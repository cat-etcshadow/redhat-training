#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Configure web server
  hosts: all
  become: true
  handlers:
    - name: restart httpd
      ansible.builtin.service:
        name: httpd
        state: restarted
  tasks:
    - name: Install httpd
      ansible.builtin.dnf:
        name: httpd
        state: present
    - name: Deploy config
      ansible.builtin.copy:
        dest: /etc/httpd/conf.d/test.conf
        content: "Listen 8080\n"
      notify: restart httpd
    - name: Start httpd
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: true
EOF
chown student:student "$PLAYBOOK_FILE"
