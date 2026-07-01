#!/usr/bin/env bash
id "$CRON_USER" &>/dev/null || useradd -M "$CRON_USER"

mkdir -p "$TOOL_DIR"
cat > "${TOOL_DIR}/custom-helper" << 'SCRIPT'
#!/usr/bin/env bash
echo "helper output"
SCRIPT
chmod 755 "${TOOL_DIR}/custom-helper"

cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/usr/bin/env bash
custom-helper >> /tmp/rhtr-custom-tool.log
SCRIPT
chmod 755 "$SCRIPT_PATH"

crontab -r -u "$CRON_USER" 2>/dev/null || true
