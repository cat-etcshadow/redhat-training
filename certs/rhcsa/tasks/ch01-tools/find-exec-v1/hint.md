## Hint

- `find /dir -type f -exec chmod 0644 {} \;` — fix each regular file
- `find /dir -type d -exec chmod 0755 {} \;` — fix each directory
- Replace `\;` with `+` to batch the arguments (faster but semantically identical)
- `-perm /o+w` matches any file where others have write permission
- After fixing, `find /dir -perm /o+w` should return nothing
