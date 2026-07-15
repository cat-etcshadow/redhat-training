## Terminate processes by name pattern, by exact name, and by PID

Three background processes are running on the system. Kill every process whose name matches the pattern `rhtr_alpha`, kill every process named exactly `rhtr_beta`, and terminate the process whose PID is stored in `/tmp/rhtr_kill_pid`. No `rhtr_alpha`, `rhtr_beta`, or the PID from `/tmp/rhtr_kill_pid` may remain running.
