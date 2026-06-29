#!/usr/bin/env bash
dnf install -y httpd &>/dev/null
systemctl enable --now httpd &>/dev/null

mkdir -p "/var/www/html/$WEBDIR"
echo "<h1>${WEBDIR} content</h1>" > /tmp/rhtr_index.html
cp /tmp/rhtr_index.html "/var/www/html/$WEBDIR/index.html"
rm -f /tmp/rhtr_index.html

# Remove any existing semanage fcontext entry for this dir so the
# candidate must add it (not just fix a pre-existing policy entry).
semanage fcontext -d "/var/www/html/${WEBDIR}(/.*)?" 2>/dev/null || true

chcon -R -t tmp_t "/var/www/html/$WEBDIR"
