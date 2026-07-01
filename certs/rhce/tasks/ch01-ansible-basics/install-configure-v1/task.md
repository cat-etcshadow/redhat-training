## Configure the Ansible Control Environment

On the control node, set up the Ansible working environment at **{{ANSIBLE_DIR}}**:

1. Create a configuration file **{{CFG_FILE}}** so that:
   - The default inventory file is `{{INVENTORY_FILE}}`
   - The default remote user is `student`
   - Host key checking is disabled

2. Create a static inventory file **{{INVENTORY_FILE}}** so that:
   - `node1` is a member of the **dev** host group
   - `node2` is a member of the **test** host group
   - `node3` and `node4` are members of the **prod** host group
   - `node5` is a member of the **balancers** host group
   - The **prod** group is a child of the **webservers** group

3. Ansible must be able to reach all managed hosts.
