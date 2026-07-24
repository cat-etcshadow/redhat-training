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
rm -f "$PLAYBOOK_FILE"
chown -R student:student "$ANSIBLE_DIR"

# pre-populate the target directory with existing files on prod nodes, so
# "apply the context to existing files" is a real, checkable action
# cd into ANSIBLE_DIR so ansible.cfg's host_key_checking=False is picked up —
# this is the first live SSH from student to node3/node4, so without it the
# unaccepted host key blocks non-interactively and ansible reports the hosts
# unreachable (rc=4), failing session setup.
su - student -c "cd $ANSIBLE_DIR && ansible prod -i $INVENTORY_FILE -m ansible.builtin.file -a 'path=$CUSTOM_DIR state=directory' -b" &>/dev/null
su - student -c "cd $ANSIBLE_DIR && ansible prod -i $INVENTORY_FILE -m ansible.builtin.copy -a 'dest=$CUSTOM_DIR/index.html content=placeholder mode=0644' -b" &>/dev/null
