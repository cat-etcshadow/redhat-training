## Hint

- `lineinfile`: `regexp:` matches the line to replace; `line:` is the replacement
- If no line matches `regexp:`, the `line:` is appended at the end of the file
- `replace`: substitutes all regex matches in the file — no `line:` parameter
- Both modules work on the remote host's filesystem with `path:` or `dest:`
- The `notify:` key takes the handler name as a string — must match exactly
- A handler only fires once per play even if notified by multiple tasks
- Test your regexp first: `grep -E 'pattern' /etc/ssh/sshd_config`
