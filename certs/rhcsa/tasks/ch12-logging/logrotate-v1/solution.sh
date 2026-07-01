#!/usr/bin/env bash
cat > "/etc/logrotate.d/${APP_NAME}" << CONF
${LOG_FILE} {
    size ${MAX_SIZE}
    rotate ${ROTATE_COUNT}
    compress
    copytruncate
    missingok
    notifempty
}
CONF
