## Install Roles from Ansible Galaxy via Requirements File

Create a requirements file **{{REQUIREMENTS_FILE}}** that specifies the following roles to install into **{{ROLES_DIR}}**:

| Source URL | Install as name |
|---|---|
| `https://github.com/geerlingguy/ansible-role-apache` | `apache` |
| `https://github.com/geerlingguy/ansible-role-mysql` | `mysql` |

Requirements:
- The file must be valid YAML
- Each entry uses `src:` (the GitHub URL or galaxy name) and `name:` (alias)
- The file must use the correct `requirements.yml` format (list under no top-level key, or under `roles:`)

Install the roles from the requirements file into **{{ROLES_DIR}}**.
