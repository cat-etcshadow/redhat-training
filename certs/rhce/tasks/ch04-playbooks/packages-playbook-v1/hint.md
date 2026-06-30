## Hint

- Multi-play playbook: two `- name:` blocks, each with their own `hosts:` line
- Host pattern for multiple groups: `hosts: dev:test:prod`
- DNF package group install: `name: "@RPM Development Tools"` (note the `@` prefix)
- Update all packages: `name: "*"` with `state: latest`
- `become: true` can go at play level (applies to all tasks in that play)
- `ansible-playbook --syntax-check -i inventory playbook.yml` validates syntax without running
