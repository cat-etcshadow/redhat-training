## Use Check Mode and Diff Mode

Create a playbook and a helper script that demonstrate Ansible's check mode and diff mode:

### Step 1: Create the playbook {{PLAYBOOK_FILE}}

Create a playbook for **dev** hosts that:
1. Deploys `/etc/motd` with content `"{{CONFIG_CONTENT}}"` using `ansible.builtin.copy`
2. Ensures the line `"# managed by ansible"` is present in `/etc/motd` using `ansible.builtin.lineinfile`

### Step 2: Create the check script {{ANSIBLE_DIR}}/check-mode.sh

Create an executable shell script that runs the playbook with both `--check`
and `--diff` flags.

Requirements:
- Playbook must pass `--syntax-check`
