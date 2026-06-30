## Query the systemd journal with journalctl

Log entries from the identifier `{{SYSLOG_ID}}` have been written to the journal.

Your task:

1. Use `journalctl` to retrieve all log entries from syslog identifier
   **{{SYSLOG_ID}}** and save the output to **{{OUTPUT_FILE}}**.
2. Use `journalctl` to retrieve all messages from the **current boot** and save
   them to **{{BOOT_LOG_FILE}}**.
