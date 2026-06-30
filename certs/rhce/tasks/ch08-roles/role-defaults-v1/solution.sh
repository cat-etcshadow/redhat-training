#!/usr/bin/env bash
mkdir -p "$ROLES_DIR/$ROLE_NAME"/{tasks,defaults,handlers,templates,vars,meta}

cat > "$ROLES_DIR/$ROLE_NAME/defaults/main.yml" <<'EOF'
---
web_port: 80
web_user: apache
EOF

cat > "$ROLES_DIR/$ROLE_NAME/tasks/main.yml" <<'EOF'
---
- name: Install httpd
  ansible.builtin.dnf:
    name: httpd
    state: present
  become: true

- name: Deploy web user config
  ansible.builtin.copy:
    content: "Listen {{ web_port }}\n"
    dest: "/etc/httpd/conf.d/{{ web_user }}.conf"
  become: true
EOF

cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Apply $ROLE_NAME role to webservers with custom port
  hosts: webservers
  become: true
  vars:
    web_port: 8080
  roles:
    - $ROLE_NAME
EOF

chown -R student:student "$ROLES_DIR" "$PLAYBOOK_FILE"
