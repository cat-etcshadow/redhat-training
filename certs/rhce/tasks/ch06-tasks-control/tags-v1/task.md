## Use Tags to Run Subsets of Tasks

Create a playbook **{{PLAYBOOK_FILE}}** for **all** hosts that contains exactly **4 tasks**, each with a different tag:

| Task | Tag | Action |
|------|-----|--------|
| 1 | `packages` | Install `vim-enhanced` using `ansible.builtin.dnf` |
| 2 | `config` | Create `/etc/myapp.conf` with content `"configured=yes"` using `ansible.builtin.copy` |
| 3 | `service` | Ensure `sshd` is started using `ansible.builtin.service` |
| 4 | `verify` | Print `inventory_hostname` using `ansible.builtin.debug` |

Additional requirements:
- At least one task must also have the `always` tag (so it always runs even with `--tags`)
- The playbook must pass `--syntax-check`
- At least 3 different tag names must be present

Verify selective execution:
```
ansible-playbook --syntax-check {{PLAYBOOK_FILE}}
ansible-playbook --list-tags {{PLAYBOOK_FILE}}
```
