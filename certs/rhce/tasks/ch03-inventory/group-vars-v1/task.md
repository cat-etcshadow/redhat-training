## Create group_vars for Host Groups

Inside **{{ANSIBLE_DIR}}**, create a `group_vars/` directory structure that defines the following variables for each host group:

| Group     | Variable   | Value            |
|-----------|-----------|------------------|
| dev       | env        | {{DEV_ENV}}      |
| test      | env        | {{TEST_ENV}}     |
| prod      | env        | {{PROD_ENV}}     |
| all       | ntp_server | 172.25.254.250   |

Requirements:
- Each group must have its own YAML file under `group_vars/<groupname>.yml`
- The `all` group file sets `ntp_server`
- All files must be valid YAML
