## Terminate processes using kill, killall, and pkill

Three background processes were started by the setup script.

Your task:

1. Use **`pkill`** to kill all processes named `rhtr_alpha`.
2. Use **`killall`** to kill all processes named `rhtr_beta`.
3. Read the PID stored in `/tmp/rhtr_kill_pid` and use **`kill`** to terminate that process.

Verify no processes remain with `pgrep` or `ps aux | grep rhtr`.
