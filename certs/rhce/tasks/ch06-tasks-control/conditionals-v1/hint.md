## Hint

- `when:` is a task-level keyword at the same indentation as `name:`
- String comparison: `when: ansible_distribution == "RedHat"`
- Numeric comparison: `when: ansible_memtotal_mb > 512`
- `ansible_os_family` is `"RedHat"` for RHEL, CentOS, Fedora; `"Debian"` for Ubuntu
- Fact names are case-sensitive
- `ansible-doc ansible.builtin.copy` — `content:` parameter writes inline text
- `ansible-doc ansible.builtin.debug` — `msg:` parameter prints a message
- To explore available facts: `ansible -m setup localhost | grep -i distribution`
