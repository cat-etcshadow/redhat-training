## Create a Cron Job via Ansible Playbook

Create a playbook **{{PLAYBOOK_FILE}}** that configures a cron job on **all** managed hosts:

- **User**: `{{CRON_USER}}`
- **Schedule**: every `{{CRON_MINUTE}}` minutes
- **Command**: `logger "EX294 exam in progress"`
- **Job name**: `exam-logger`

Requirements:
- Use the `ansible.builtin.cron` module
- `become: true` is required to manage cron for other users
- The user `{{CRON_USER}}` must exist on the managed host (create them with `ansible.builtin.user` if needed)
- The playbook must pass `--syntax-check`
