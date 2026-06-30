## Configure Privilege Escalation with become_user

Create a playbook **{{PLAYBOOK_FILE}}** that demonstrates privilege escalation on the **dev** host group:

1. The play must use `become: true` at the play level
2. Add a task that creates the system account **{{TARGET_USER}}** if it does not exist:
   - Use `ansible.builtin.user` module
   - Set `system: true`
3. Add a second task that uses `become_user: {{TARGET_USER}}` to write a file `/tmp/priv_test.txt` owned by **{{TARGET_USER}}**:
   - Content: `"privilege escalation test"`
   - Use `ansible.builtin.copy` module with `become_user: {{TARGET_USER}}`

Requirements:
- The playbook must pass `--syntax-check`
- Both `become: true` (play level) and `become_user: {{TARGET_USER}}` (task level) must be present
- `{{TARGET_USER}}` must be referenced as the target user

Verify:
```
ansible-playbook --syntax-check {{PLAYBOOK_FILE}}
```
