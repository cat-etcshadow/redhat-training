#!/usr/bin/env bash
mkdir -p "$(dirname "$PLAYBOOK_FILE")/templates"
cat > "$(dirname "$PLAYBOOK_FILE")/templates/index.html.j2" <<EOF
$BANNER_TEXT
{{ ansible_hostname }}
EOF

cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Deploy and harden company web server
  hosts: prod
  become: true
  vars:
    web_root: "$WEB_ROOT"

  tasks:
    - name: Install httpd
      ansible.builtin.dnf:
        name: httpd
        state: present

    - name: Create web root directory
      ansible.builtin.file:
        path: "{{ web_root }}"
        state: directory
        owner: apache
        group: apache
        mode: '0755'

    - name: Grant httpd access to the custom document root
      ansible.builtin.copy:
        dest: /etc/httpd/conf.d/webcontent.conf
        content: |
          <Directory "{{ web_root }}">
              Require all granted
          </Directory>
        owner: root
        group: root
        mode: '0644'
      notify: restart httpd

    - name: Set custom DocumentRoot
      ansible.builtin.lineinfile:
        path: /etc/httpd/conf/httpd.conf
        regexp: '^DocumentRoot'
        line: 'DocumentRoot "{{ web_root }}"'
      notify: restart httpd

    - name: Persistent SELinux context for web root
      community.general.sefcontext:
        target: "{{ web_root }}(/.*)?"
        setype: httpd_sys_content_t
        state: present
      notify: restore selinux context

    - name: Deploy templated home page
      ansible.builtin.template:
        src: templates/index.html.j2
        dest: "{{ web_root }}/index.html"
        owner: apache
        group: apache
        mode: '0644'
      notify: restart httpd

    - name: Open firewall for http
      ansible.posix.firewalld:
        service: http
        permanent: true
        immediate: true
        state: enabled

    - name: Ensure httpd is running and enabled
      ansible.builtin.systemd:
        name: httpd
        state: started
        enabled: true

  handlers:
    - name: restore selinux context
      ansible.builtin.command: "restorecon -Rv {{ web_root }}"

    - name: restart httpd
      ansible.builtin.systemd:
        name: httpd
        state: restarted
EOF
chown -R student:student "$(dirname "$PLAYBOOK_FILE")"
