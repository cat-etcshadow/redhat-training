## Configure journald for persistent log storage

By default, journald stores logs in memory and they are lost on reboot.

Your task:

1. Configure **journald** to store logs persistently on disk.
2. Set the maximum journal disk usage to **100M**.
3. Restart the `systemd-journald` service to apply the changes.
4. Verify persistent storage is active: `journalctl --disk-usage` should
   show journal files in `/var/log/journal/`.
