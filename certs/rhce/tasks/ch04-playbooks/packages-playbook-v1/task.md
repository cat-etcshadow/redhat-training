## Install Packages via Playbook

Create a playbook **{{PLAYBOOK_FILE}}** that manages software installation across host groups:

1. **Play 1** — runs on hosts in **dev**, **test**, and **prod** groups:
   - Install the packages: `php` and `mariadb`

2. **Play 2** — runs on hosts in the **dev** group only:
   - Install the package group: `RPM Development Tools`
   - Update all packages to the latest version

Requirements:
- Use the `ansible.builtin.dnf` module (not `yum`)
- The playbook must pass `ansible-playbook --syntax-check`
- Use `become: true` where root privileges are needed
