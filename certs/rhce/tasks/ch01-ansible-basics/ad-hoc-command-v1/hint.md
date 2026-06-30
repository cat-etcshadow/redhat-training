## Hint

- Ad-hoc syntax: `ansible <pattern> -m <module> -a "<args>" [-i inventory]`
- Pattern examples: `all`, `dev`, `prod`, `node1`
- `ansible.builtin.ping` — no args needed, just tests connectivity
- `ansible.builtin.package` — args: `name=<pkg> state=present`; needs `--become` for root install
- `ansible.builtin.command` — args: the command string; `hostname` returns the node's hostname
- Make the script executable: `chmod +x adhoc.sh`
