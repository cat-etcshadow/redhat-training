#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'OUTERSCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 3 ]]; then
  echo "Usage: gen_config.sh <user> <port> <config-dir>" >&2
  exit 1
fi
user="$1"
port="$2"
confdir="$3"
mkdir -p "$confdir"

cat > "${confdir}/app.conf" <<EOF
[app]
user = ${user}
port = ${port}
log_level = info
EOF

echo "Generated config in $confdir"
OUTERSCRIPT
chmod +x "$SCRIPT_PATH"
