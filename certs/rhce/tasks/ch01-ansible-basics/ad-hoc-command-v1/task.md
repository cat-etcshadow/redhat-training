## Use Ansible Ad-Hoc Commands

Create a shell script **{{SCRIPT_FILE}}** that uses ansible ad-hoc commands to perform the following actions (assume ansible.cfg is already configured in **{{ANSIBLE_DIR}}**):

1. Use the `ansible.builtin.ping` module to verify connectivity to **all** managed hosts.
2. Use the `ansible.builtin.package` module to install **{{INSTALL_PKG}}** on all hosts in the **dev** group.
3. Use the `ansible.builtin.command` module to collect the hostname of every host in the **prod** group and print the results.

Requirements:
- The script must be executable.
- Each ad-hoc command must be on its own line and reference the inventory at **{{INVENTORY_FILE}}**.
