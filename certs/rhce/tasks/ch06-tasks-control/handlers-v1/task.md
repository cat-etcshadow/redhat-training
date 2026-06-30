## Configure Apache with Handlers

Create a playbook **{{PLAYBOOK_FILE}}** that configures Apache httpd on hosts in the **webservers** group:

1. Install the `httpd` package
2. Deploy a custom `/etc/httpd/conf.d/custom.conf` containing:
   ```
   Listen {{LISTEN_PORT}}
   ```
3. Enable and start the `httpd` service
4. Open port **{{LISTEN_PORT}}/tcp** in the firewall using the `ansible.posix.firewalld` module

Handlers:
- Any change to the configuration file must trigger a **restart** of the `httpd` service
- The handler must be named `restart httpd`

Requirements:
- Use `become: true`
- The playbook must pass `--syntax-check`
