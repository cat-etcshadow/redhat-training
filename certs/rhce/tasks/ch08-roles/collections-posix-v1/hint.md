## Hint

- Install a collection to a specific path: `ansible-galaxy collection install namespace.name -p /path/to/collections`
- The collection will be placed under: `path/ansible_collections/namespace/name/`
- `collections_paths` in `ansible.cfg` tells Ansible where to look for collections
- `ansible.posix` ships with RHEL in the `ansible-collection-ansible-posix` package too
- `ansible.posix.sysctl`: manages kernel parameters persistently (writes to `/etc/sysctl.d/`)
  - `reload: true` applies the change immediately via `sysctl -p`
  - `state: present` ensures the parameter exists with the given value
- Verify installation: `ansible-galaxy collection list` or `ls $COLLECTIONS_DIR/ansible_collections/`
