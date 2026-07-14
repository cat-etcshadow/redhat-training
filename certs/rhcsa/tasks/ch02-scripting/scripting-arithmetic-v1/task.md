## Write a script that evaluates a usage threshold with integer arithmetic

Create an executable script at **{{SCRIPT_PATH}}** that reports resource
usage as a percentage.

Requirements:

1. Accepts exactly two arguments: `<used>` and `<total>`, both non-negative
   integers. If the argument count is wrong, or either argument is not a
   non-negative integer, print a usage message to stderr and exit **3**.

2. Using **integer arithmetic**, compute the percentage:
   `pct = used * 100 / total`

3. Print `Usage: <pct>%`.

4. Based on `pct`:
   - `pct >= 80` → print `WARNING` and exit **1**
   - `pct < 80` → print `OK` and exit **0**

The script must be executable.
