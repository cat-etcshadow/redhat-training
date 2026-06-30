## Manage Firewall Rules with Ansible

Create a playbook **{{PLAYBOOK_FILE}}** that targets all hosts in the **webservers** group and:

1. Opens the `{{FW_SERVICE}}` service in firewalld permanently and immediately
2. Opens port `{{FW_PORT}}/tcp` in firewalld permanently and immediately

Requirements:
- Use `ansible.posix.firewalld` for both tasks
- Both rules must have `permanent: true` and `immediate: true`
- Both must have `state: enabled`
- Use `become: true`
- The playbook must pass `--syntax-check`
