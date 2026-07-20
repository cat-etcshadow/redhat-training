#!/usr/bin/env bash
cat > /usr/local/bin/rhtr-hog.sh <<'EOF'
#!/usr/bin/env bash
while true; do :; done
EOF
chmod 755 /usr/local/bin/rhtr-hog.sh
pkill -f rhtr-hog.sh 2>/dev/null || true
sleep 1
nohup /usr/local/bin/rhtr-hog.sh </dev/null >/dev/null 2>&1 &
disown
