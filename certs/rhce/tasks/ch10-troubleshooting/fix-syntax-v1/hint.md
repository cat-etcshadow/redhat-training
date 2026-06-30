## Hint

- Run `ansible-playbook --syntax-check broken.yml` to see the first error
- YAML requires consistent indentation — use 2 spaces (no tabs)
- Every key-value pair needs a colon followed by a space: `key: value` (not `key value`)
- String values after colons usually need quotes if they contain special chars: `content: "text"`
- Handler `notify:` value must match the handler `name:` exactly (case-sensitive)
- Use `python3 -m yaml broken.yml` or `yamllint broken.yml` for detailed YAML error messages
- Fix one error at a time and re-run `--syntax-check` between fixes
