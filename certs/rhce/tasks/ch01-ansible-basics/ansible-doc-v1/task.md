## Use ansible-doc to Discover Module Parameters

Create a playbook **{{PLAYBOOK_FILE}}** that targets **all** hosts and inserts a block of text into `{{TARGET_FILE}}`:

- Block content: `{{BLOCK_CONTENT}}`
- Marker: `# {{MARKER}} {mark}` (where `{mark}` is a literal placeholder that becomes BEGIN/END)

Requirements:
- Use `ansible.builtin.blockinfile`
- Set `marker:` to `"# {{MARKER}} {mark}"` exactly (with the literal `{mark}` token)
- Set `create: true` so the file is created if it does not exist
- Use `become: true`
- The playbook must pass `--syntax-check`
