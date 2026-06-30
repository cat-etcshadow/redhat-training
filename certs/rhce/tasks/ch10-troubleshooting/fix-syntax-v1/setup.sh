#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR"
cat > "$ANSIBLE_DIR/ansible.cfg" <<'EOF'
[defaults]
inventory = /home/student/ansible/inventory
remote_user = student
host_key_checking = False
EOF
cat > "$INVENTORY_FILE" <<'EOF'
[dev]
node1

[test]
node2

[prod]
node3
node4

[balancers]
node5

[webservers:children]
prod
balancers
EOF

# create the broken playbook with deliberate errors:
# 1. missing --- at top (not an error in ansible but sets context)
# 2. wrong indentation on tasks
# 3. missing colon on a key
# 4. notify references non-matching handler name
cat > "$PLAYBOOK_FILE" <<'BROKEN'
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
        content "Listen 8080\n"
      notify: restart httpd
    - name: Start httpd
      ansible.builtin.service:
        name: httpd
        state started
        enabled: true
BROKEN

chown -R student:student "$ANSIBLE_DIR"
