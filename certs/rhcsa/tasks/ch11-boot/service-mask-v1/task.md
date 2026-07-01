## Mask a deprecated service to prevent it from starting

The unit **{{UNIT_NAME}}.service** is deprecated and must never run again —
not even if someone manually tries `systemctl start`.

Your task:

**Mask** **{{UNIT_NAME}}.service** so that any attempt to start it fails.
