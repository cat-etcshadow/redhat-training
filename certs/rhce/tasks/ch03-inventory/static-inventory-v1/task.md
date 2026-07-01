## Create a Static Inventory File

Create a static inventory file at **{{INVENTORY_FILE}}** with the following layout:

| Host  | Group       |
|-------|-------------|
| node1 | dev         |
| node2 | test        |
| node3 | prod        |
| node4 | prod        |
| node5 | balancers   |

Additional requirements:
- The **prod** group must be a child of **webservers**.
- The **balancers** group must also be a child of **webservers**.
- Each host should appear only once in the file.
