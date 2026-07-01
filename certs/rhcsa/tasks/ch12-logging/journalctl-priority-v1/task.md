## Filter journal entries by priority level

The identifier **{{SYSLOG_ID}}** has logged messages at multiple priority
levels, including one at **info** and one at **err**.

Your task:

Using `journalctl`, find only the entries for **{{SYSLOG_ID}}** at priority
**err** or higher, and save the output to **{{OUTPUT_FILE}}**. The
info-level message must **not** appear in the output.
