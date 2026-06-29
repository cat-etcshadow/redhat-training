#!/usr/bin/env bash
groupadd "$WEB_GROUP" 2>/dev/null || true
useradd -M -G "$WEB_GROUP" "$WEB_USER" 2>/dev/null || true

rm -rf "$WEB_ROOT"
mkdir -p "$WEB_ROOT/css" "$WEB_ROOT/js" "$WEB_ROOT/images"
echo "<html><body>site</body></html>" > "$WEB_ROOT/index.html"
echo "body { margin: 0; }" > "$WEB_ROOT/css/main.css"
echo "console.log('ready')" > "$WEB_ROOT/js/app.js"
dd if=/dev/urandom bs=256 count=1 2>/dev/null > "$WEB_ROOT/images/logo.png"

# deliberately broken permissions
chown -R root:root "$WEB_ROOT"
find "$WEB_ROOT" -type d -exec chmod 0700 {} +
find "$WEB_ROOT" -type f -exec chmod 0600 {} +
