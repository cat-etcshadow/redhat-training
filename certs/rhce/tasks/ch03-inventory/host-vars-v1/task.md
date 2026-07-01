## Create host_vars with Per-Host Variables

On the control node, configure per-host variables using the `host_vars` directory:

1. Create the directory `{{ANSIBLE_DIR}}/host_vars/`
2. Create `{{ANSIBLE_DIR}}/host_vars/node1.yml` containing:
   ```yaml
   http_port: 8080
   ```
3. Create `{{ANSIBLE_DIR}}/host_vars/node2.yml` containing:
   ```yaml
   http_port: 9090
   ```
4. Create a playbook **{{PLAYBOOK_FILE}}** that:
   - Targets the **dev** and **test** groups (`hosts: dev:test`)
   - Uses the `ansible.builtin.debug` module to print the `http_port` variable for each host
