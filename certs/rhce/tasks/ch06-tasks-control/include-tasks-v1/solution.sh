#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR/tasks"

cat > "$MAIN_PLAYBOOK" <<'EOF'
---
- name: Deploy httpd using modular task files
  hosts: webservers
  become: true
  handlers:
    - name: restart httpd
      ansible.builtin.service:
        name: httpd
        state: restarted
  tasks:
    - name: Include install tasks
      ansible.builtin.include_tasks: tasks/install.yml

    - name: Include config tasks
      ansible.builtin.include_tasks: tasks/config.yml
EOF

cat > "$TASKS_FILE_INSTALL" <<'EOF'
---
- name: Install httpd package
  ansible.builtin.dnf:
    name: httpd
    state: present
EOF

cat > "$TASKS_FILE_CONFIG" <<'EOF'
---
- name: Deploy custom httpd config
  ansible.builtin.copy:
    content: "# managed by ansible\nServerName {{ inventory_hostname }}\n"
    dest: /etc/httpd/conf.d/custom.conf
  notify: restart httpd
EOF

chown -R student:student "$ANSIBLE_DIR"
