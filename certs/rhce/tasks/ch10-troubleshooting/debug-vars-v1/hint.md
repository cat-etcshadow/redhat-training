## Hint

- `ansible.builtin.debug` with `msg:`: print a formatted string with `{{ variable }}`
- `ansible.builtin.debug` with `var:`: dump a variable's value directly (no `{{ }}` needed)
- `register: varname` — captures a task's output into `varname`
- Registered variable fields: `.stdout`, `.stderr`, `.rc`, `.stdout_lines`
- `ansible_facts['os_family']` — values like `RedHat`, `Debian`
- `ansible_facts['memtotal_mb']` — total RAM in MB
- Run with verbosity: `ansible-playbook -v playbook.yml` shows task output; `-vvv` shows connection details
- `ansible node1 -m ansible.builtin.setup | grep memtotal` — check a specific fact quickly
