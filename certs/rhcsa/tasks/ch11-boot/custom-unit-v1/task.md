## Create and enable a custom systemd service unit

A script has been placed at `/usr/local/bin/{{UNIT_SCRIPT}}`.

Your task:

1. Create a systemd unit file at `/etc/systemd/system/{{UNIT_NAME}}.service`:
   - Description: `{{UNIT_DESC}}`
   - Type: `oneshot`, with `RemainAfterExit=yes`
   - ExecStart: `/usr/local/bin/{{UNIT_SCRIPT}}`
   - Wanted by `multi-user.target`

2. Reload the systemd daemon so it recognises the new unit.

3. Enable and start the unit.
