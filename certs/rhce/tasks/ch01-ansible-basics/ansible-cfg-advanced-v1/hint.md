## Hint

- All advanced settings go in the `[defaults]` section of `ansible.cfg`
- `forks` controls parallel execution — higher values are faster but use more resources
- `log_path` must point to a writable file path; the directory must exist
- `roles_path` and `collections_paths` accept absolute paths
- For yaml output: use `stdout_callback = yaml` (Ansible 2.9+) or `callback_whitelist = yaml` (older)
- Test with: `ansible-config dump --only-changed` to see which settings are active
- Verify forks: `ansible-config dump | grep FORKS`
