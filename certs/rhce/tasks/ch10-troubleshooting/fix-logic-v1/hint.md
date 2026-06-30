## Hint

**Bug 1 — group membership test:**
- Wrong: `when: group_names == 'dev'` (comparing list to string — always False)
- Right: `when: "'dev' in group_names"` (membership test on the list)

**Bug 2 — loop variable sub-key:**
- When looping over a list of dicts, `item` is the whole dict
- Access sub-keys with dot notation: `item.name`, `item.version`
- Wrong: `{{ item }}` when item is `{name: httpd, version: latest}`
- Right: `{{ item.name }}`

**Bug 3 — registered variable attributes:**
- `ansible.builtin.command` returns: `rc`, `stdout`, `stderr`, `stdout_lines`, `stderr_lines`
- There is no `.output` attribute — that's a common mistake
- Right: `result.stdout` for captured standard output

**General debugging:**
- `ansible-playbook --syntax-check` catches YAML and module errors
- Run with `-vvv` for verbose output during actual execution
