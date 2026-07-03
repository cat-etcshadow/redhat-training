## Run a Playbook Inside an Execution Environment

The playbook **{{PLAYBOOK_FILE}}** and inventory **{{INVENTORY_FILE}}**
already exist.

Your task:

1. Pull the Execution Environment image **{{EE_IMAGE}}** with `podman`.
2. Configure **{{NAVIGATOR_CFG}}** so that:
   - `execution-environment: enabled: true`
   - `execution-environment: image: {{EE_IMAGE}}`
3. Using that configuration, run **{{PLAYBOOK_FILE}}** with
   `ansible-navigator run` in `stdout` mode, and confirm it completes
   successfully **inside the Execution Environment container** — not using
   the local Ansible install.
