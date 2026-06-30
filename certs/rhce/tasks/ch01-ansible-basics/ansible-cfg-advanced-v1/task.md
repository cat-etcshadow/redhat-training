## Configure Advanced ansible.cfg Settings

On the control node, modify or create the Ansible configuration file **{{CFG_FILE}}** with the following advanced settings in the `[defaults]` section:

1. Set `forks = {{FORKS}}` — controls how many hosts Ansible manages in parallel
2. Set `log_path = {{LOG_PATH}}` — writes output to a log file
3. Set `roles_path = {{ROLES_DIR}}` — custom roles directory
4. Set `collections_paths = {{COLLECTIONS_DIR}}` — custom collections directory
5. Set either `stdout_callback = yaml` or add `yaml` to `callback_whitelist` — makes output more readable

The existing `inventory`, `remote_user`, and `host_key_checking` settings from the base configuration must be preserved.

Verify with:
```
ansible --version | grep 'config file'
ansible-config dump | grep FORKS
```
