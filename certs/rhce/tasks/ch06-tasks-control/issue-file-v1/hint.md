## Hint

- `group_names` is a built-in Ansible variable: list of all groups the current host belongs to
- Check membership: `when: "'dev' in group_names"`
- `ansible.builtin.copy` with `content:` writes a string directly; use `\n` at the end for a newline
- Separate task per group: each task has its own `when:` condition
- Alternative: use a variable and `set_fact` then a single copy task
- `ansible-doc ansible.builtin.copy` — check the `content` parameter
