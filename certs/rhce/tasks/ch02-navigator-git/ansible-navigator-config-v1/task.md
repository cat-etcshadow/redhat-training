## Configure and Run a Playbook with ansible-navigator

The playbook **{{PLAYBOOK_FILE}}** and inventory **{{INVENTORY_FILE}}**
already exist.

Your task:

1. Create an `ansible-navigator` configuration file at **{{NAVIGATOR_CFG}}**
   so that:
   - Execution environment support is disabled (`execution-environment:
     enabled: false`), so playbooks run using the local Ansible install
   - The inventory entry points at **{{INVENTORY_FILE}}**
2. Using that configuration, run **{{PLAYBOOK_FILE}}** with
   `ansible-navigator run` in `stdout` mode and confirm it completes
   successfully.
