## Deploy a Service with Firewall Rules

Create a playbook **{{PLAYBOOK_FILE}}** that runs on **all** managed hosts and:

1. Installs the `{{SERVICE_NAME}}` package using `ansible.builtin.dnf`
2. Enables and starts the `{{SERVICE_NAME}}` service using `ansible.builtin.service`:
   - `enabled: true`
   - `state: started`
3. Opens the `{{FIREWALL_SERVICE}}` service in the firewall using `ansible.posix.firewalld`:
   - `service: {{FIREWALL_SERVICE}}`
   - `permanent: true`
   - `state: enabled`
   - `immediate: true`

Requirements:
- Use `become: true`
- The playbook must pass `--syntax-check`
- All three modules must be present
