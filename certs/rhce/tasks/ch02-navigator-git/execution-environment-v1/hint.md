## Hint

- `podman pull quay.io/ansible/awx-ee:latest`
- `execution-environment: enabled: true` plus `execution-environment: image:
  <name>` under the `ansible-navigator:` key
- With execution environments enabled, `ansible-navigator` mounts your
  playbook/inventory into the container and runs `ansible-playbook` inside it
- `podman image exists <image>` checks whether an image has already been
  pulled without printing anything
