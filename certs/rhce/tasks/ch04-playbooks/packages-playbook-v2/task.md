## Multi-Group Package Deployment Playbook

Create a playbook **{{PLAYBOOK_FILE}}** with multiple plays that handle different package sets per group:

**Play 1** — targets **webservers** group:
- Install `{{PKG1}}` and `{{PKG2}}` at the `latest` version using `ansible.builtin.dnf`

**Play 2** — targets **dev** group only:
- Install `{{PKG3}}` using `ansible.builtin.dnf` with `state: present`

**Play 3** — targets **test** group:
- Ensure all installed packages are at the latest version:
  ```yaml
  name: "*"
  state: latest
  ```

Requirements:
- All plays must use `become: true`
- Package names `{{PKG1}}`, `{{PKG2}}`, and `{{PKG3}}` must be referenced
- The playbook must pass `--syntax-check`
