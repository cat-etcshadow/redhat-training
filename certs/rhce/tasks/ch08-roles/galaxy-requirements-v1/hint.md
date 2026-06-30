## Hint

- `requirements.yml` format: a YAML list, each item has `src:` and optionally `name:`, `version:`
- `src:` accepts: galaxy name (`namespace.role`), GitHub URL, tarball URL
- `name:` sets an alias for the installed role directory
- Install: `ansible-galaxy install -r requirements.yml -p roles/`
- `-p roles/` — install into the `roles/` directory (rather than `~/.ansible/roles`)
- Check installed: `ansible-galaxy list`
- `version:` is optional; omit to get latest
