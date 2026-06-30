## Create a Role with Defaults and Variable Overrides

Create an Ansible role **{{ROLE_NAME}}** in **{{ROLES_DIR}}** with the following structure:

### Role: {{ROLES_DIR}}/{{ROLE_NAME}}/

**defaults/main.yml** — define default values:
```yaml
web_port: 80
web_user: apache
```

**tasks/main.yml** — role tasks (use `become: true`):
- Install `httpd` package using `ansible.builtin.dnf`
- Create the file `/etc/httpd/conf.d/{{ web_user }}.conf` using `ansible.builtin.copy`:
  - Content: `"Listen {{ web_port }}"`

### Playbook: {{PLAYBOOK_FILE}}

Create a playbook that:
- Targets **webservers** group
- Applies the role **{{ROLE_NAME}}**
- **Overrides** `web_port` to `8080` in the play's `vars:` section

Requirements:
- Role directory structure must exist under `{{ROLES_DIR}}/{{ROLE_NAME}}/`
- `defaults/main.yml` must define `web_port` and `web_user`
- Playbook must override `web_port: 8080`
- Playbook must pass `--syntax-check`
