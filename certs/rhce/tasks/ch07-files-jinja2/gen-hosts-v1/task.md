## Generate a Hosts File Using a Jinja2 Template

**Step 1:** Create a Jinja2 template **{{TEMPLATE_FILE}}** that generates a hosts file with:
- Two static lines:
  ```
  127.0.0.1 localhost localhost.localdomain
  ::1       localhost localhost.localdomain
  ```
- One line for **every host** in the inventory, in the format:
  ```
  <ip_address> <fqdn> <shortname>
  ```
  Use `hostvars`, `groups['all']`, `ansible_facts['default_ipv4']['address']`, and `ansible_facts['fqdn']`.

**Step 2:** Create a playbook **{{PLAYBOOK_FILE}}** that:
- Runs on **all** managed hosts (to gather facts)
- Deploys the rendered template to **{{OUTPUT_FILE}}** on hosts in the **{{TARGET_GROUP}}** group only
- Uses the `ansible.builtin.template` module

Requirements:
- The playbook must pass `--syntax-check`
- The template must loop over `groups['all']` to produce one line per host
