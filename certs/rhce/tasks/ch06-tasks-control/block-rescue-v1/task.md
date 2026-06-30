## Error Handling with block/rescue/always

Create a playbook **{{PLAYBOOK_FILE}}** that runs on **dev**, **test**, and **prod** groups and uses block/rescue/always for resilient httpd deployment:

**BLOCK** section:
- Install the `httpd` package using `ansible.builtin.dnf`
- Start the `httpd` service using `ansible.builtin.service` with `state: started`

**RESCUE** section:
- Print a debug message: `"httpd setup failed"` using `ansible.builtin.debug`

**ALWAYS** section:
- Ensure the file `/tmp/deploy_status.txt` exists with content `"attempted"` using `ansible.builtin.copy`

Additional requirements:
- Use `become: true`
- All three sections (`block:`, `rescue:`, `always:`) must be present
- `/tmp/deploy_status.txt` must be referenced with content `"attempted"`
- The playbook must pass `--syntax-check`
