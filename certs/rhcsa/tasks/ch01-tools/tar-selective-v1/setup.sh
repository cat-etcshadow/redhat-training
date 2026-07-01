#!/usr/bin/env bash
rm -rf /root/rhtr-bundle-src "$ARCHIVE" "$EXTRACT_DIR"
mkdir -p /root/rhtr-bundle-src/{docs,config,meta,release,logs,src}

echo "readme content"           > /root/rhtr-bundle-src/README.md
echo "release notes content"    > /root/rhtr-bundle-src/docs/release-notes.txt
echo "config: true"             > /root/rhtr-bundle-src/config/config.yaml
echo '{"version":1}'            > /root/rhtr-bundle-src/meta/manifest.json
echo "v1.0 changes"             > /root/rhtr-bundle-src/release/changelog.md
echo "log line"                 > /root/rhtr-bundle-src/logs/app.log
echo "print('hi')"              > /root/rhtr-bundle-src/src/main.py

tar -czf "$ARCHIVE" -C /root/rhtr-bundle-src .
