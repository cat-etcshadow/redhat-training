## Create a custom rsyslog rule to filter log messages

Your task:

1. Install **rsyslog** if not already installed and ensure it is running.
2. Create a custom rsyslog configuration file at `{{CONF_FILE}}` that:
   - Captures all **{{FACILITY}}** facility messages at **{{SEVERITY}}** severity or higher
   - Writes them to **{{LOG_FILE}}**
3. Restart rsyslog to apply the configuration.
4. Test by logging a synthetic message:
   ```
   logger -p {{FACILITY}}.{{SEVERITY}} "Test message"
   ```
   and verify it appears in `{{LOG_FILE}}`.
