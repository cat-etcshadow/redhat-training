## Write a script that evaluates a usage threshold with integer arithmetic

Create an executable script at **{{SCRIPT_PATH}}** that reports resource usage as a percentage. It must accept exactly two arguments, `<used>` and `<total>`, both non-negative integers; if the argument count is wrong, or either argument is not a non-negative integer, print a usage message to stderr and exit **3**. Using integer arithmetic, it must compute `pct = used * 100 / total`, print `Usage: <pct>%`, then print `WARNING` and exit **1** when `pct >= 80`, or print `OK` and exit **0** when `pct < 80`.
