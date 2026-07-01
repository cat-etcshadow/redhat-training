#!/usr/bin/env bash
dnf install -y nfs-utils &>/dev/null

rm -rf "$EXPORT_DIR"
mkdir -p "$EXPORT_DIR"
echo "shared content" > "${EXPORT_DIR}/readme.txt"

mkdir -p /etc/exports.d
echo "${EXPORT_DIR} 127.0.0.1(ro,no_root_squash)" > /etc/exports.d/rhtr-showmount.exports
systemctl enable --now nfs-server &>/dev/null
exportfs -ra &>/dev/null

umount -f "$MOUNT_POINT" 2>/dev/null || true
sed -i "\\|${MOUNT_POINT}|d" /etc/fstab 2>/dev/null || true
rm -rf "$MOUNT_POINT"
mkdir -p "$MOUNT_POINT"
rm -f "$REPORT_FILE"
