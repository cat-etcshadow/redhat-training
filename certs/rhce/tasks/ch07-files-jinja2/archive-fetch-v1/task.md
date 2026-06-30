## Archive and Fetch Files from Remote Hosts

Create a playbook **{{PLAYBOOK_FILE}}** for **dev** hosts that:

1. Creates a compressed archive of the `/etc/ssh/` directory on the remote host:
   - Destination: `/tmp/{{ARCHIVE_NAME}}`
   - Use `ansible.builtin.archive` module
   - Format: `gz` (gzip-compressed tar)

2. Fetches the archive from each remote host back to the control node:
   - Use `ansible.builtin.fetch` module
   - `src: /tmp/{{ARCHIVE_NAME}}`
   - `dest: {{FETCH_DEST}}/{{ inventory_hostname }}/`
   - Set `flat: false` to preserve the path structure

Requirements:
- Use `become: true`
- Both `archive` and `fetch` modules must be present
- `/etc/ssh` must be referenced as the source directory
- `{{FETCH_DEST}}` must be referenced as the destination
- The playbook must pass `--syntax-check`
