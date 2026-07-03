## Terminate processes by name pattern, by exact name, and by PID

Three background processes were started by the setup script.

Your task:

1. Kill every process whose name matches the pattern `rhtr_alpha`.
2. Kill every process named exactly `rhtr_beta`.
3. Read the PID stored in `/tmp/rhtr_kill_pid` and terminate that specific process.

No `rhtr_alpha`, `rhtr_beta`, or the PID from `/tmp/rhtr_kill_pid` may remain running.
