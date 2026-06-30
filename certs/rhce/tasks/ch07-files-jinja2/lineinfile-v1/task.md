## Modify SSH Config with lineinfile and replace

Create a playbook **{{PLAYBOOK_FILE}}** for **all** hosts that hardens the SSH configuration:

1. Use `ansible.builtin.lineinfile` to ensure this exact line is present in `{{CONFIG_FILE}}`:
   ```
   {{CONFIG_LINE}}
   ```
   - Use a `regexp:` pattern to match and replace any existing occurrence of the directive
   - Set `line:` to the exact value: `{{CONFIG_LINE}}`

2. Use `ansible.builtin.replace` to change any commented-out `#PermitEmptyPasswords` line to:
   ```
   PermitEmptyPasswords no
   ```
   - `regexp: '^#PermitEmptyPasswords.*'`
   - `replace: 'PermitEmptyPasswords no'`

3. Add a handler named `restart sshd` that restarts the `sshd` service
4. Both tasks must notify the `restart sshd` handler

Requirements:
- Use `become: true`
- The playbook must pass `--syntax-check`
