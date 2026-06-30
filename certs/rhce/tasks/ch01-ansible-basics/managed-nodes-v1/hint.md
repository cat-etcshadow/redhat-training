## Hint

- `ansible-doc ansible.builtin.user` — `name:`, `state: present`
- `ansible-doc ansible.posix.authorized_key` — `user:`, `key:`, `state: present`
- `ansible-doc ansible.builtin.copy` — use `content:` for inline text, `dest:` for path, `mode:` for permissions
- Sudoers drop-in must have mode `0440` (root-readable only) or `visudo` will reject it
- Sudoers content format: `username ALL=(ALL) NOPASSWD: ALL`
- Add a trailing newline to the sudoers content string: `"user ALL=(ALL) NOPASSWD: ALL\n"`
- Task order: create user → deploy SSH key → configure sudoers
