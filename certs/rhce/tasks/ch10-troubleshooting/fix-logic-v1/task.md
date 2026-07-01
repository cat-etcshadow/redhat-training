## Fix Incorrect Logic in a Broken Playbook

The file **{{PLAYBOOK_FILE}}** contains three logic bugs. Find and fix all of them so the playbook passes `--syntax-check` and behaves as intended:

1. A task should print a message only when the host is in the **dev** group.
2. A task loops over a list of package dicts (each with a `name` key) and should print the package name being installed.
3. A task registers the output of a `command`, then should print that command's captured standard output.
