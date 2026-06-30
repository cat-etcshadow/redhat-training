## Manage SELinux Policy with Ansible

Create a playbook **{{PLAYBOOK_FILE}}** that targets all hosts in the **prod** group and:

1. Sets the SELinux file context type `{{SELINUX_TYPE}}` on `{{CUSTOM_DIR}}` and all its contents using the regex pattern `{{CUSTOM_DIR}}(/.*)?`
2. Applies the context change with `restorecon -Rv {{CUSTOM_DIR}}`
3. Enables the SELinux boolean `{{SELINUX_BOOLEAN}}` persistently

Requirements:
- Use `community.general.sefcontext` for the file context (`state: present`)
- Use `ansible.builtin.command` with `restorecon -Rv {{CUSTOM_DIR}}` to apply the context
- Use `ansible.posix.seboolean` for the boolean (`persistent: yes`)
- Tasks must run in order: sefcontext → restorecon → seboolean
- Use `become: true`
- The playbook must pass `--syntax-check`
