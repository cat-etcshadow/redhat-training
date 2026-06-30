#!/usr/bin/env bash
cat > "$YAML_INVENTORY_FILE" <<'EOF'
---
all:
  children:
    dev:
      hosts:
        node1:
    test:
      hosts:
        node2:
    prod:
      hosts:
        node3:
        node4:
    balancers:
      hosts:
        node5:
    webservers:
      children:
        prod:
        balancers:
EOF

chown student:student "$YAML_INVENTORY_FILE"
