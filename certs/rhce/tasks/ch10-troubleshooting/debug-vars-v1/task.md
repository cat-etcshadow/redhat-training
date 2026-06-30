## Debug Variables with the debug Module

Create a playbook **{{PLAYBOOK_FILE}}** that runs on **all** managed hosts and demonstrates debugging techniques:

1. Print the value of `inventory_hostname` using `ansible.builtin.debug`
2. Print the value of `ansible_facts['os_family']`
3. Print the total memory in MB (`ansible_facts['memtotal_mb']`)
4. Use `ansible.builtin.debug` with `var:` to dump the entire `ansible_facts['network_interfaces']` dictionary
5. Register the output of `ansible.builtin.command` running `uptime` into a variable called `uptime_result`, then print `uptime_result.stdout`

Requirements:
- The playbook must pass `--syntax-check`
- Each debug task must have a meaningful `name:`
