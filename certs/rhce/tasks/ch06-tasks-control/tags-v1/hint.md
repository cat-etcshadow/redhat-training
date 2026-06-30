## Hint

- `tags:` is a list under a task — each tag is a separate list item
- A task can have multiple tags: `tags: [packages, always]`
- Run specific tags: `ansible-playbook playbook.yml --tags packages`
- Skip specific tags: `ansible-playbook playbook.yml --skip-tags config`
- The `always` tag is special — tasks tagged `always` run even when using `--tags other`
- The `never` tag is the opposite — those tasks only run when explicitly requested
- List all tags: `ansible-playbook playbook.yml --list-tags`
