#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Configure yum repositories
  hosts: all
  become: true
  tasks:
    - name: Configure BaseOS repository
      ansible.builtin.yum_repository:
        name: BaseOS
        description: Base OS Repo
        baseurl: file:///mnt/BaseOS/
        gpgcheck: yes
        enabled: no
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

    - name: Configure AppStream repository
      ansible.builtin.yum_repository:
        name: AppStream
        description: AppStream Repo
        baseurl: file:///mnt/AppStream/
        gpgcheck: yes
        enabled: no
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF
chown student:student "$PLAYBOOK_FILE"
