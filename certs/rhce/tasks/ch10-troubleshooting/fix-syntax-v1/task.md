## Fix Syntax Errors in a Broken Playbook

The playbook **{{PLAYBOOK_FILE}}** contains multiple syntax/structural errors. Fix it so that:

1. `ansible-playbook --syntax-check -i {{INVENTORY_FILE}} {{PLAYBOOK_FILE}}` passes without errors
2. The playbook logic is preserved:
   - It targets all hosts
   - It installs the `httpd` package
   - It starts and enables the `httpd` service
   - It notifies the `restart httpd` handler when the config file changes

Do not rewrite the whole playbook — identify and correct the specific errors.
