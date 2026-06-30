## Deploy a MOTD Template Using Jinja2

**Step 1:** Create group_vars to define a `motd_message` variable for each group:
- `dev` → `"Welcome to Development"`
- `test` → `"Welcome to Testing"`
- `prod` → `"Welcome to Production"`

**Step 2:** Create a Jinja2 template **{{TEMPLATE_FILE}}** for `/etc/motd` with the content:
```
{{ motd_message }}
Managed by Ansible — hostname: {{ ansible_facts['hostname'] }}
```

**Step 3:** Create a playbook **{{PLAYBOOK_FILE}}** that:
- Runs on **all** managed hosts
- Deploys the template to `/etc/motd` using `ansible.builtin.template`
- Requires `become: true`

The playbook must pass `--syntax-check`.
