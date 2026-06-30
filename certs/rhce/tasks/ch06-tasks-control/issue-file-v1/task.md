## Configure /etc/issue Based on Host Group

Create a playbook **{{PLAYBOOK_FILE}}** that runs on all inventory hosts and sets the contents of `/etc/issue` based on which group the host belongs to:

| Group | /etc/issue content   |
|-------|----------------------|
| dev   | {{DEV_MSG}}          |
| test  | {{TEST_MSG}}         |
| prod  | {{PROD_MSG}}         |

Requirements:
- Single play targeting **all** hosts
- Use `when:` conditions with `group_names` to determine which message to write
- Use the `ansible.builtin.copy` module with `content:` to write the file
- `become: true` is required
- The playbook must pass `--syntax-check`
