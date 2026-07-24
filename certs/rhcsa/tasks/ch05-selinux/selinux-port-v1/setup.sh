#!/usr/bin/env bash
dnf install -y httpd policycoreutils-python-utils &>/dev/null
# Remove port if previously added (idempotent cleanup)
semanage port -d -t http_port_t -p tcp "$HTTP_PORT" 2>/dev/null || true
# Reset Listen to default 80
sed -i "s/^Listen .*/Listen 80/" /etc/httpd/conf/httpd.conf
# Deliberately doesn't stop/disable httpd — a sibling ch05 task
# (fix-file-context-v1) enables it as part of its own setup, and grading
# here only checks the FINAL running/enabled state (which the candidate
# must still ensure regardless), not a specific starting transition.
