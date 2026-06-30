## Create a Custom Apache Role

Create a role named **{{ROLE_NAME}}** in **{{ROLES_DIR}}** with the following behaviour:

**tasks/main.yml** must:
1. Install the `httpd` package
2. Enable and start the `httpd` service
3. Configure the firewall to allow the `http` service (using `ansible.posix.firewalld`)
4. Deploy the template `index.html.j2` to `/var/www/html/index.html`

**templates/index.html.j2** must produce:
```
Welcome to {{ ansible_facts['fqdn'] }} on {{ ansible_facts['default_ipv4']['address'] }}
```

**handlers/main.yml** must define a handler `restart httpd` that restarts the httpd service.

The tasks that deploy the template must `notify: restart httpd`.

**Create a playbook {{PLAYBOOK_FILE}}** that applies the **{{ROLE_NAME}}** role to hosts in the **webservers** group.

The playbook must pass `--syntax-check`.
