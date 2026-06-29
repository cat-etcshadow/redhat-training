## Write a script using functions

Create an executable script at **{{SCRIPT_PATH}}** that generates a disk usage report.

The script must define and use the following **functions**:

### `print_header`
Prints a header line:
```
=== Disk Usage Report: <date> ===
```
where `<date>` is the current date in `%Y-%m-%d` format.

### `check_mountpoint <path>`
Takes one argument (a mount point path).
- If the path is mounted, prints: `OK   <path>  <used>/<size> (<percent>%)`
  (use `df -h "$path"` to get figures)
- If the path is not mounted or doesn't exist, prints: `WARN <path>  NOT MOUNTED`

### `main`
Calls `print_header`, then calls `check_mountpoint` for: `/`, `/boot`, `/tmp`, `/var`

Script must:
- Accept an optional argument `--output <file>` that redirects all output to the file
  instead of stdout. If `--output` is used, also exit 0 silently.
- Be executable.

Example:
```
$ disk_report.sh
=== Disk Usage Report: 2025-03-15 ===
OK   /       8.2G/20G (42%)
OK   /boot   150M/1G (15%)
WARN /tmp    NOT MOUNTED
WARN /var    NOT MOUNTED
```
