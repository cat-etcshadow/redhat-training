## Deploy and Use Custom Ansible Facts

Create a playbook **{{PLAYBOOK_FILE}}** that performs the following on **all** managed hosts:

1. Ensure the custom facts directory `/etc/ansible/facts.d/` exists on each managed host.
2. Deploy a custom fact file `/etc/ansible/facts.d/custom.fact` with the following INI-format content:
   ```ini
   [packages]
   web_package = {{FACT_PKG}}
   db_package = {{FACT_SVC}}
   ```
3. Re-gather facts so the new custom facts become available in the current play (use `ansible.builtin.setup`).
4. Print (using `ansible.builtin.debug`) the value of `ansible_local.custom.packages.web_package`.

Requirements:
- The playbook must pass `--syntax-check`
- Use `become: true` for file operations
