#!/usr/bin/env bash
mkdir -p "$ROLES_DIR/$ROLE_NAME"/{tasks,handlers,templates,defaults,vars,meta}

cat > "$ROLES_DIR/$ROLE_NAME/tasks/main.yml" <<'EOF'
---
- name: Install httpd
  ansible.builtin.dnf:
    name: httpd
    state: present

- name: Enable and start httpd
  ansible.builtin.service:
    name: httpd
    state: started
    enabled: true

- name: Configure firewall for http
  ansible.posix.firewalld:
    service: http
    permanent: true
    state: enabled
    immediate: true

- name: Deploy index.html from template
  ansible.builtin.template:
    src: index.html.j2
    dest: /var/www/html/index.html
  notify: restart httpd
EOF

cat > "$ROLES_DIR/$ROLE_NAME/handlers/main.yml" <<'EOF'
---
- name: restart httpd
  ansible.builtin.service:
    name: httpd
    state: restarted
EOF

cat > "$ROLES_DIR/$ROLE_NAME/templates/index.html.j2" <<'EOF'
Welcome to {{ ansible_facts['fqdn'] }} on {{ ansible_facts['default_ipv4']['address'] }}
EOF

cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Apply apache role to webservers
  hosts: webservers
  become: true
  roles:
    - $ROLE_NAME
EOF

chown -R student:student "$ROLES_DIR" "$PLAYBOOK_FILE"
