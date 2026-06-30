#!/usr/bin/env bash
cat > "$TEMPLATE_FILE" <<'EOF'
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
::1       localhost localhost.localdomain localhost6 localhost6.localdomain6
{% for host in groups['all'] %}
{{ hostvars[host]['ansible_facts']['default_ipv4']['address'] }} {{ hostvars[host]['ansible_facts']['fqdn'] }} {{ hostvars[host]['ansible_facts']['hostname'] }}
{% endfor %}
EOF

cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Gather facts from all hosts
  hosts: all
  gather_facts: true

- name: Generate /etc/myhosts on dev hosts
  hosts: $TARGET_GROUP
  become: true
  tasks:
    - name: Deploy hosts template
      ansible.builtin.template:
        src: $TEMPLATE_FILE
        dest: $OUTPUT_FILE
EOF
chown student:student "$PLAYBOOK_FILE" "$TEMPLATE_FILE"
