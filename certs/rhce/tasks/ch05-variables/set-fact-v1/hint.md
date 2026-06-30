## Hint

- `set_fact:` creates a variable scoped to the current host for the rest of the play
- `group_names` is a list of all groups the current host belongs to
- Check membership: `when: "'groupname' in group_names"`
- `groups` is a dict of all groups → list of hostnames: `groups['prod']` returns `['node3', 'node4']`
- Use the `length` filter to count: `groups['prod'] | length`
- `set_fact` tasks without `when:` always run — add conditions to make them conditional
- `gather_facts: false` speeds up the playbook when facts aren't needed (remove if you need `ansible_facts`)
