## Configure Advanced ansible.cfg Settings

On the control node, modify or create the Ansible configuration file **{{CFG_FILE}}** with the following advanced settings in the `[defaults]` section:

1. Set `forks = {{FORKS}}`
2. Set `log_path = {{LOG_PATH}}`
3. Set `roles_path = {{ROLES_DIR}}`
4. Set `collections_paths = {{COLLECTIONS_DIR}}`
5. Set either `stdout_callback = yaml` or add `yaml` to `callback_whitelist`

The existing `inventory`, `remote_user`, and `host_key_checking` settings from the base configuration must be preserved.
