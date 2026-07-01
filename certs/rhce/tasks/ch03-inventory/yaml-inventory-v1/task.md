## Create a YAML Format Inventory

Create a YAML-format inventory file at **{{YAML_INVENTORY_FILE}}** that replicates the standard group structure:

- Group **dev**: contains `node1`
- Group **test**: contains `node2`
- Group **prod**: contains `node3` and `node4`
- Group **balancers**: contains `node5`
- Group **webservers**: parent group with children **prod** and **balancers**

All five nodes (node1–node5) and all groups must appear in the inventory.
