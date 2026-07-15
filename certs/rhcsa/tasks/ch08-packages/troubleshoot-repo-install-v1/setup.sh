#!/usr/bin/env bash
cat > /etc/yum.repos.d/rhtr-internal.repo <<'EOF'
[rhtr-internal]
name=RHTR Internal Repository
baseurl=http://repo.internal.example.corp/rhtr/$releasever/$basearch/
enabled=1
gpgcheck=0
skip_if_unavailable=False
EOF
dnf clean expire-cache &>/dev/null || true
