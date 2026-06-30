## Configure Managed Nodes for Ansible Access

Create a playbook **{{PLAYBOOK_FILE}}** that targets **all** hosts and prepares them to be managed by Ansible:

1. Creates user `{{ANSIBLE_USER}}` if it does not exist
2. Deploys the following SSH public key for `{{ANSIBLE_USER}}`:
   ```
   {{SSH_KEY}}
   ```
3. Grants `{{ANSIBLE_USER}}` passwordless sudo by creating `/etc/sudoers.d/{{ANSIBLE_USER}}` with content:
   ```
   {{ANSIBLE_USER}} ALL=(ALL) NOPASSWD: ALL
   ```

Requirements:
- Use `ansible.builtin.user` to create the user
- Use `ansible.posix.authorized_key` to deploy the SSH key
- Use `ansible.builtin.copy` for the sudoers file with `mode: '0440'`
- Use `become: true`
- The playbook must pass `--syntax-check`
