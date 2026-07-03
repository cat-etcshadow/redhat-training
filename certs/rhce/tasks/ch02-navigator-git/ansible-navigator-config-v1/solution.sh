#!/usr/bin/env bash
cat > "$NAVIGATOR_CFG" <<EOF
---
ansible-navigator:
  execution-environment:
    enabled: false
  playbook-artifact:
    enable: false
  inventory:
    entries:
      - $INVENTORY_FILE
EOF
chown student:student "$NAVIGATOR_CFG"
