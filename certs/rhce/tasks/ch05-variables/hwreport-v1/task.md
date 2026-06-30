## Generate a Hardware Report Using Ansible Facts

Create a playbook **{{PLAYBOOK_FILE}}** that generates a hardware report file **{{REPORT_PATH}}** on every managed host.

Each line in the report must follow the format `KEY=value`:

```
INVENTORY_HOSTNAME=<ansible inventory hostname>
TOTAL_MEMORY_IN_MB=<total RAM in MB>
BIOS_VERSION=<BIOS version string>
```

Requirements:
- The playbook runs on **all** managed hosts
- Use Ansible facts (`ansible_facts`) — do not hard-code any values
- Use the `ansible.builtin.copy` module with `content:` to write the file
- If any fact is unavailable, write `NONE` for that value
- The playbook must pass `--syntax-check`
