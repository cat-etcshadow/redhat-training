## Write a script using functions

Create an executable script at **{{SCRIPT_PATH}}** that generates a disk usage report.

The script must define and use **functions**, including one for printing a
report header (with the current date) and one for checking a single mount
point (reporting whether it's mounted, and its usage if so).

The script must:
- Check `/`, `/boot`, `/tmp`, and `/var`.
- Report each mount point's status as OK or WARN.
- Accept an optional argument `--output <file>` that redirects all output to
  the file instead of stdout, exiting 0 silently.
- Be executable.
