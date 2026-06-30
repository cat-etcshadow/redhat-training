## Hint

- `handlers:` block is at the same level as `tasks:` in a play
- Handlers only run if a task that uses `notify:` actually changes
- `notify: handler_name` — the name must match exactly (case-sensitive)
- Handler runs once at the end of the play, not immediately when notified
- `ansible.posix.firewalld` parameters: `port: 8080/tcp`, `state: enabled`, `permanent: true`, `immediate: true`
- `ansible-doc ansible.builtin.service` — check `state: restarted` vs `reloaded`
