## Hint

- `block:`, `rescue:`, and `always:` are at the same indentation level as each other
- They are nested inside the play's `tasks:` list as a single item
- `rescue:` only executes if a task inside `block:` fails
- `always:` always executes, regardless of block/rescue outcome
- `ansible.builtin.copy` with `content:` creates a file with inline text
- A block can inherit `become: true` from the play — no need to repeat it on the block
- Verify structure: the block/rescue/always construct is a single YAML mapping in tasks
