## Hint

- `dnf install /path/to/package.rpm` — install from a local file (resolves deps)
- `rpm -ivh /path/to/package.rpm` — install without dep resolution
- `rpm -q <package>` — check if a package is installed
- `createrepo_c <dir>` — generate repo metadata (repodata/) from RPMs in a dir
- `file://` URI in baseurl points to a local directory: `file:///opt/myrepo`
- `gpgcheck=0` disables GPG signature verification (needed for custom repos)
- `dnf repolist` shows all enabled repos; `dnf repolist all` includes disabled ones
