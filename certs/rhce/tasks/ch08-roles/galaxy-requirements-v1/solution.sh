#!/usr/bin/env bash
cat > "$REQUIREMENTS_FILE" <<'EOF'
---
- src: https://github.com/geerlingguy/ansible-role-apache
  name: apache
- src: https://github.com/geerlingguy/ansible-role-mysql
  name: mysql
EOF

# install roles (requires internet access at setup time)
su - student -c "ansible-galaxy install -r '$REQUIREMENTS_FILE' -p '$ROLES_DIR'" 2>/dev/null || true
chown -R student:student "$ANSIBLE_DIR"
