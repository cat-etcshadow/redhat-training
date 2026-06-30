#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Deploy Apache with handler
  hosts: webservers
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

    - name: Deploy custom config
      ansible.builtin.copy:
        dest: /etc/httpd/conf.d/custom.conf
        content: "Listen $LISTEN_PORT\n"
      notify: restart httpd

    - name: Enable and start httpd
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: true

    - name: Open firewall port
      ansible.posix.firewalld:
        port: ${LISTEN_PORT}/tcp
        permanent: true
        state: enabled
        immediate: true
EOF
chown student:student "$PLAYBOOK_FILE"
