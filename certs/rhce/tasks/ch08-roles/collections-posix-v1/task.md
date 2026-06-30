## Install and Use an Ansible Collection

Configure Ansible to use a custom collections directory and install the `ansible.posix` collection:

### Steps:

1. Update `{{ANSIBLE_DIR}}/ansible.cfg` to set `collections_paths = {{COLLECTIONS_DIR}}`

2. Install the `ansible.posix` collection to the custom path:
   ```
   ansible-galaxy collection install ansible.posix -p {{COLLECTIONS_DIR}}
   ```

3. Create a playbook **{{PLAYBOOK_FILE}}** for **all** hosts that:
   - Uses `ansible.posix.sysctl` to set `vm.swappiness = 10` permanently.

Requirements:
- `collections_paths = {{COLLECTIONS_DIR}}` must be in `ansible.cfg`
- The `ansible.posix` collection must be installed under `{{COLLECTIONS_DIR}}`
- Playbook must use `ansible.posix.sysctl`
- Playbook must pass `--syntax-check`
