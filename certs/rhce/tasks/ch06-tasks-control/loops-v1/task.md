## Install Packages and Create Users Using Loops

Create a playbook **{{PLAYBOOK_FILE}}** that targets the **dev** group and performs:

1. Installs the following packages using a **single task** with `loop:`:
   - `{{PKG1}}`
   - `{{PKG2}}`
   - `{{PKG3}}`

2. Creates a local user for each of the following names using a **single task** with `loop:`:
   - `{{USER1}}`
   - `{{USER2}}`
   - `{{USER3}}`

Requirements:
- Use `ansible.builtin.dnf` for package installation
- Use `ansible.builtin.user` for user creation
- Use the modern `loop:` keyword (not `with_items`)
- Use `become: true`
- The playbook must pass `--syntax-check`
