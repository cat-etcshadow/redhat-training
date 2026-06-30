## Manage Users, Groups, and SSH Keys

Create a playbook **{{PLAYBOOK_FILE}}** that targets all hosts in the **prod** group and:

1. Creates a group named `{{GROUP_NAME}}` with GID `{{GROUP_GID}}`
2. Creates a user named `{{USER_NAME}}` with:
   - UID `{{USER_UID}}`
   - Primary group `{{GROUP_NAME}}`
   - Shell `{{USER_SHELL}}`
3. Deploys the following SSH public key for `{{USER_NAME}}`:
   ```
   {{SSH_KEY}}
   ```

Requirements:
- Use `ansible.builtin.group` for the group
- Use `ansible.builtin.user` for the user
- Use `ansible.posix.authorized_key` for the SSH key
- The group must be created before the user (task ordering matters)
- Use `become: true`
- The playbook must pass `--syntax-check`
