## Apply Conditional Tasks Based on OS Facts

Create a playbook **{{PLAYBOOK_FILE}}** that targets **all** hosts and:

1. Installs the `{{PACKAGE}}` package **only when** `ansible_distribution` is `"RedHat"`
2. Creates the file `{{STATUS_FILE}}` with content `"RedHat system configured"` **only when** `ansible_os_family` is `"RedHat"`
3. Prints a debug message `"Sufficient memory available"` **only when** `ansible_memtotal_mb` is greater than `{{MIN_MEMORY}}`

Requirements:
- Each task must use a `when:` clause
- Use `ansible.builtin.dnf` for the package
- Use `ansible.builtin.copy` for the file (with `content:` parameter)
- Use `ansible.builtin.debug` for the message (with `msg:` parameter)
- Use `become: true`
- The playbook must pass `--syntax-check`
