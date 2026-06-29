## Configure journald persistent storage and max size

By default, journald may store logs in volatile memory only. You need to configure
it to persist logs across reboots and cap their disk usage.

Your task:

1. Configure **journald** to store logs persistently on disk.
2. Cap the total journal disk usage at **{{MAX_USE}}**.
3. Restart the journald service to apply the changes.
4. Verify: `journalctl --disk-usage` should show usage, and
   `journalctl -b` should contain entries from the current boot.
