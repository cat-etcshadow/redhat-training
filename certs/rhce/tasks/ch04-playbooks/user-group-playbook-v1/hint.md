## Hint

- `ansible-doc ansible.builtin.group` — parameters: `name`, `gid`, `state`
- `ansible-doc ansible.builtin.user` — parameters: `name`, `uid`, `group`, `shell`, `state`
- `ansible-doc ansible.posix.authorized_key` — parameters: `user`, `key`, `state`
- Create the group before the user — the user task references the group by name
- The `key:` parameter in `authorized_key` takes the full public key string including type prefix
- `group:` in the user task sets the primary group; use `groups:` for supplementary groups
