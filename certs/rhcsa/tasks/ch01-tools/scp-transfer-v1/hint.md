## Hint

- `scp /local/file user@host:/remote/path` — copy a single file
- `scp -r /local/dir user@host:/remote/` — copy a directory recursively
- `rsync -av /src/ /dst/` — sync directory contents (note trailing slash on source)
- `rsync -av /src /dst/` — without trailing slash, copies the `src` directory itself inside `dst`
- `rsync --dry-run` previews what would change without doing anything
- For `scp` to localhost, SSH must be running and key auth configured
