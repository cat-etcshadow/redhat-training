## Hint

- `become: true` at play level enables privilege escalation for all tasks
- `become_user: username` on a specific task changes which user runs that task
- System accounts: use `ansible.builtin.user` with `system: true`
- `become_user` requires `become: true` to already be active
- The default `become_method` is `sudo` — student must have sudo rights
- `/tmp/priv_test.txt` ownership is set by the `owner:` parameter in `ansible.builtin.copy`
