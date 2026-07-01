#!/usr/bin/env bash
dnf install -y httpd &>/dev/null
systemctl enable --now httpd &>/dev/null

mkdir -p "/var/www/html/$WEBDIR"

echo "<h1>${WEBDIR}</h1>" > /tmp/rhtr_page.html
chcon -t tmp_t /tmp/rhtr_page.html

# Copy with --preserve=context, carrying the wrong (tmp_t) context along
# with it into a directory that already has a correct default policy.
cp --preserve=context /tmp/rhtr_page.html "/var/www/html/${WEBDIR}/page.html"
rm -f /tmp/rhtr_page.html
