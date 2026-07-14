## Write a script using functions

Create an executable script at **{{SCRIPT_PATH}}** that generates a disk usage report.

The script must define and use **functions**, including one for printing a
report header (with the current date) and one for checking a single mount
point (reporting whether it's mounted, and its usage if so).

The script must:
- Check `/` and `/boot`.
- Report each mount point's status as OK or WARN.
- Be executable.
