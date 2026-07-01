## Configure logrotate for a custom application log

The application log **{{LOG_FILE}}** is not currently managed by logrotate.

Your task:

Create a logrotate configuration at **/etc/logrotate.d/{{APP_NAME}}** for
**{{LOG_FILE}}** that:

1. Rotates the log once it exceeds **{{MAX_SIZE}}**.
2. Keeps **{{ROTATE_COUNT}}** rotated copies.
3. Compresses rotated logs.
4. Uses `copytruncate` (the application keeps its log file open and does
   not support reopening it after rotation).
