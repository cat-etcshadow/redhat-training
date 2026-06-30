#!/usr/bin/env bash
cat > "$SCRIPT_FILE" <<EOF
#!/usr/bin/env bash
cd "$ANSIBLE_DIR"
ansible all -i "$INVENTORY_FILE" -m ansible.builtin.ping
ansible dev -i "$INVENTORY_FILE" -m ansible.builtin.package -a "name=$INSTALL_PKG state=present" --become
ansible prod -i "$INVENTORY_FILE" -m ansible.builtin.command -a "hostname"
EOF
chmod +x "$SCRIPT_FILE"
chown student:student "$SCRIPT_FILE"
