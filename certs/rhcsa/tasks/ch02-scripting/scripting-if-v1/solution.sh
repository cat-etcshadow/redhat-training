#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 1 ]]; then
  echo "Usage: check_user.sh <username>" >&2
  exit 1
fi

username="$1"
if id "$username" &>/dev/null; then
  uid=$(id -u "$username")
  echo "User $username exists with UID $uid"
  exit 0
else
  echo "User $username does not exist"
  exit 2
fi
SCRIPT
chmod +x "$SCRIPT_PATH"
