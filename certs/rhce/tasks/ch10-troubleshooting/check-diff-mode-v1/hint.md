## Hint

- `--check` (dry-run): simulates the playbook without making changes — modules report what would change
- `--diff`: shows a unified diff of file changes — what was there vs what would be written
- Combining both: `ansible-playbook --check --diff playbook.yml` shows predicted changes safely
- `--syntax-check`: validates YAML and module usage without connecting to hosts
- Not all modules support check mode — some always report "changed" or skip in check mode
- `ansible.builtin.copy` and `ansible.builtin.lineinfile` both support check + diff properly
- Use `check_mode: true` in a task to always run it in check mode even without the CLI flag
