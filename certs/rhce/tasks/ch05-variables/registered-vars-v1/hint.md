## Hint

- `register: varname` saves the full result object of any task
- The return object has keys: `rc` (return code), `stdout`, `stderr`, `stdout_lines`
- `rc == 0` means the command succeeded (service is active)
- `ignore_errors: true` prevents the play from stopping if the command fails
- `when: svc_result.rc == 0` uses Python comparison syntax
- Ansible auto-gathers facts at play start — `ansible_facts['uptime_seconds']` is always available
- Alternative syntax: `ansible_uptime_seconds` (injected into play variables)
