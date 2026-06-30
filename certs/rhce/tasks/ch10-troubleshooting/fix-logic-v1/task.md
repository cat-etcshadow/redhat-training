## Fix Incorrect Logic in a Broken Playbook

The file **{{PLAYBOOK_FILE}}** contains three bugs. Find and fix all of them so the playbook passes `--syntax-check`.

### Bug 1 — Wrong `when` condition

**Incorrect:**
```yaml
when: group_names == 'dev'
```

### Bug 2 — Wrong loop variable access

**Incorrect:**
```yaml
name: "Install {{ item }}"
```
where `item` is a dict with a `name` key.

### Bug 3 — Wrong registered variable attribute

**Incorrect:**
```yaml
msg: "{{ result.output }}"
```

After fixing all three bugs, the playbook must pass:
```
ansible-playbook --syntax-check {{PLAYBOOK_FILE}}
```
