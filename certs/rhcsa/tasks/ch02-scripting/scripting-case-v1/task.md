## Write a script using a case statement

Create an executable script at **{{SCRIPT_PATH}}** that acts as a simple
service controller wrapper.

Requirements:

1. Accepts exactly **two arguments**: `<action>` and `<service-name>`.
   If wrong number of args, print usage to stderr and exit **1**.

2. Uses a **`case`** statement on `<action>`:
   - `start`   → run `systemctl start <service>` and print `Starting <service>`
   - `stop`    → run `systemctl stop <service>` and print `Stopping <service>`
   - `restart` → run `systemctl restart <service>` and print `Restarting <service>`
   - `status`  → run `systemctl status <service>` (let its output pass through)
   - `enable`  → run `systemctl enable --now <service>` and print `Enabling <service>`
   - `*`       → print `Unknown action: <action>` to stderr and exit **3**

3. Propagate the exit code from `systemctl` (if it fails, the script fails too).

4. Exit **0** on success.

```bash
case "$action" in
  start)   ... ;;
  stop)    ... ;;
  restart) ... ;;
  status)  ... ;;
  enable)  ... ;;
  *)       echo "Unknown action: $action" >&2; exit 3 ;;
esac
```
