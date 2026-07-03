#!/usr/bin/env bash
su - student -c "podman pull $EE_IMAGE"
cat > "$NAVIGATOR_CFG" <<EOF
---
ansible-navigator:
  execution-environment:
    enabled: true
    image: $EE_IMAGE
  playbook-artifact:
    enable: false
  inventory:
    entries:
      - $INVENTORY_FILE
EOF
chown student:student "$NAVIGATOR_CFG"
