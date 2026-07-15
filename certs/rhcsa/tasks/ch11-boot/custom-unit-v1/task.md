## Create and enable a custom systemd service unit

A script has been placed at `/usr/local/bin/{{UNIT_SCRIPT}}`. Create a systemd unit file at `/etc/systemd/system/{{UNIT_NAME}}.service` with description `{{UNIT_DESC}}`, type `oneshot` with `RemainAfterExit=yes`, `ExecStart=/usr/local/bin/{{UNIT_SCRIPT}}`, and wanted by `multi-user.target`. Enable and start the unit.
