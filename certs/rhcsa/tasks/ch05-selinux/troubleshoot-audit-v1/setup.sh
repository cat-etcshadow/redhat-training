#!/usr/bin/env bash
dnf install -y httpd &>/dev/null
systemctl enable --now httpd &>/dev/null
# Disable CGI execution via SELinux boolean
setsebool -P httpd_enable_cgi off
# Create a test CGI script so the denial can be observed
mkdir -p /var/www/cgi-bin
cat > /var/www/cgi-bin/test.cgi <<'EOF'
#!/usr/bin/env bash
echo "Content-type: text/plain"
echo ""
echo "CGI works"
EOF
chmod 755 /var/www/cgi-bin/test.cgi
# Trigger an AVC denial so it appears in the audit log
curl -s http://localhost/cgi-bin/test.cgi &>/dev/null || true
