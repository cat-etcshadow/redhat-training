#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR/group_vars/all"

# write plain variables
cat > "$ANSIBLE_DIR/group_vars/all/main.yml" <<'EOF'
---
ntp_server: 172.25.254.250
EOF

# write vault password file
printf '%s' "$VAULT_PASS" > "$VAULT_PASS_FILE"
chmod 600 "$VAULT_PASS_FILE"

# create and encrypt secrets file
cat > "$ANSIBLE_DIR/group_vars/all/secrets.yml" <<'EOF'
---
db_password: "s3cr3t"
api_key: "abc123"
EOF

ansible-vault encrypt --vault-password-file "$VAULT_PASS_FILE" \
  "$ANSIBLE_DIR/group_vars/all/secrets.yml"

# create playbook
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Show group vars including vault secrets
  hosts: all
  gather_facts: false
  tasks:
    - name: Print ntp_server
      ansible.builtin.debug:
        msg: "NTP server: {{ ntp_server }}"

    - name: Print db_password
      ansible.builtin.debug:
        msg: "DB password: {{ db_password }}"
EOF

chown -R student:student "$ANSIBLE_DIR"
