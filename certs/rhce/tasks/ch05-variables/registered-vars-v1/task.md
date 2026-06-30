## Register Command Output and Use in Conditionals

Create a playbook **{{PLAYBOOK_FILE}}** for **all** hosts that:

1. Runs `systemctl is-active {{CHECK_SERVICE}}` using `ansible.builtin.command` and **registers** the result as `svc_result`

2. Uses `ansible.builtin.debug` with a `when:` condition to print:
   - `"{{CHECK_SERVICE}} is running"` when `svc_result.rc == 0`
   - `"{{CHECK_SERVICE}} is stopped"` when `svc_result.rc != 0`

3. Uses `ansible.builtin.setup` to gather facts (or relies on automatic fact gathering)

4. Prints the host's uptime using `ansible.builtin.debug`:
   ```yaml
   msg: "Uptime: {{ ansible_facts['uptime_seconds'] }} seconds"
   ```

Requirements:
- Use `register: svc_result` on the command task
- Use `when:` conditions referencing `svc_result.rc`
- The playbook must pass `--syntax-check`
- Set `ignore_errors: true` on the command task (service may not be installed)
