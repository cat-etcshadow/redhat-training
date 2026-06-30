## Use set_fact and Magic Variables

Create a playbook **{{PLAYBOOK_FILE}}** for **all** hosts that demonstrates `set_fact` and magic variables:

1. Use `ansible.builtin.set_fact` to set a variable `server_role` based on the host's group membership (`group_names`):
   - If the host is in the `dev` group → `server_role: "development server"`
   - If the host is in the `prod` group → `server_role: "production server"`
   - Otherwise → `server_role: "other server"`

   Use three separate `set_fact` tasks with `when:` conditions referencing `group_names`.

2. Print `server_role` using `ansible.builtin.debug`

3. Print the number of hosts in the `prod` group using `ansible.builtin.debug`:
   ```yaml
   msg: "There are {{ groups['prod'] | length }} production hosts"
   ```

Requirements:
- `set_fact:` must be used
- `group_names` must be referenced in `when:` conditions
- `groups['prod']` or `groups.prod` must be referenced
- The playbook must pass `--syntax-check`
