#!/usr/bin/env bash
mkdir -p "$COLLECTIONS_DIR"

# update ansible.cfg to include collections_paths
grep -qE "collections_paths" "$ANSIBLE_DIR/ansible.cfg" \
  || echo "collections_paths = $COLLECTIONS_DIR" >> "$ANSIBLE_DIR/ansible.cfg"

# install the collection
su - student -c "ansible-galaxy collection install ansible.posix -p $COLLECTIONS_DIR" &>/dev/null \
  || ansible-galaxy collection install ansible.posix -p "$COLLECTIONS_DIR"

cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Configure kernel parameters using ansible.posix.sysctl
  hosts: all
  become: true
  tasks:
    - name: Set vm.swappiness to 10 permanently
      ansible.posix.sysctl:
        name: vm.swappiness
        value: '10'
        state: present
        reload: true
EOF

chown -R student:student "$ANSIBLE_DIR" "$COLLECTIONS_DIR"
