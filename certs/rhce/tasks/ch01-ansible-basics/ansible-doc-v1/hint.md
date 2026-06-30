## Hint

- Run `ansible-doc ansible.builtin.blockinfile` to see all parameters
- Key parameters:
  - `path:` — file to modify
  - `block:` — text to insert between the markers
  - `marker:` — wraps the block; `{mark}` is replaced with `BEGIN` or `END`
  - `create: true` — creates the file if it does not exist
  - `state: present` — inserts the block (default)
- Custom marker example: `marker: "# MY SECTION {mark}"`
  - Results in: `# MY SECTION BEGIN` ... `# MY SECTION END`
- The `{mark}` token in `marker:` is mandatory — without it Ansible cannot locate the block on subsequent runs
