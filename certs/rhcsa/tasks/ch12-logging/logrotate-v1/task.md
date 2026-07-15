## Configure logrotate for a custom application log

The application log **{{LOG_FILE}}** is not currently managed by logrotate. Create a logrotate configuration at **/etc/logrotate.d/{{APP_NAME}}** for **{{LOG_FILE}}** that rotates the log once it exceeds **{{MAX_SIZE}}**, keeps **{{ROTATE_COUNT}}** rotated copies, compresses rotated logs, and uses `copytruncate`.
