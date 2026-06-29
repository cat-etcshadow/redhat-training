#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 2 ]]; then
  echo "Usage: svc_ctl.sh <action> <service>" >&2
  exit 1
fi
action="$1"
service="$2"
case "$action" in
  start)
    echo "Starting $service"
    systemctl start "$service"
    ;;
  stop)
    echo "Stopping $service"
    systemctl stop "$service"
    ;;
  restart)
    echo "Restarting $service"
    systemctl restart "$service"
    ;;
  status)
    systemctl status "$service"
    ;;
  enable)
    echo "Enabling $service"
    systemctl enable --now "$service"
    ;;
  *)
    echo "Unknown action: $action" >&2
    exit 3
    ;;
esac
SCRIPT
chmod +x "$SCRIPT_PATH"
