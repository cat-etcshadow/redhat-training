## Hint

- `ansible.builtin.include_tasks: filename.yml` loads tasks at runtime (dynamic)
- `ansible.builtin.import_tasks: filename.yml` loads tasks at parse time (static)
- The path to the included file is relative to the playbook's directory
- Handlers are defined in the main playbook — they can be notified from included task files
- The handler name in `notify:` must exactly match the handler's `name:` field
- Task files (included) are just a flat YAML list of tasks, not a full playbook (no `- hosts:`)
- `include_tasks` supports `when:`, `loop:`, and variables — `import_tasks` has more restrictions
