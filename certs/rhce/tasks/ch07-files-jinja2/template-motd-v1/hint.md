## Hint

- Templates use `{{ variable }}` for substitution and `{% %}` for control flow
- Variables from group_vars are automatically available in templates
- `ansible_facts['hostname']` — short hostname of the managed node
- `ansible.builtin.template` parameters: `src:` (local .j2 file), `dest:` (remote path)
- group_vars file must be in `group_vars/<groupname>.yml` relative to the inventory or playbook
- Template files conventionally end in `.j2` but any name works
