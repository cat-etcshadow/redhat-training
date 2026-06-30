## Modular Playbooks with include_tasks

Create a modular Ansible structure using `include_tasks` for httpd deployment on **webservers**:

### Main playbook: {{MAIN_PLAYBOOK}}

The main playbook must:
- Target `webservers` group
- Use `become: true`
- Define a handler named `restart httpd` that restarts the httpd service
- Include tasks from `{{TASKS_FILE_INSTALL}}` using `ansible.builtin.include_tasks`
- Include tasks from `{{TASKS_FILE_CONFIG}}` using `ansible.builtin.include_tasks`

### Install tasks file: {{TASKS_FILE_INSTALL}}

Must contain at least:
- A task that installs `httpd` using `ansible.builtin.dnf`

### Config tasks file: {{TASKS_FILE_CONFIG}}

Must contain at least:
- A task that deploys `/etc/httpd/conf.d/custom.conf` using `ansible.builtin.copy`
- The task must notify the `restart httpd` handler

Requirements:
- The `tasks/` subdirectory must exist under `{{ANSIBLE_DIR}}`
- Both task files must exist as separate files
- The main playbook must pass `--syntax-check`
