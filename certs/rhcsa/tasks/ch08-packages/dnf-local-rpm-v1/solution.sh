#!/usr/bin/env bash
RPM_FILE=$(ls "${LOCAL_RPM_DIR}"/*.rpm | head -1)
dnf install -y "$RPM_FILE"

dnf install -y createrepo_c &>/dev/null
createrepo_c "$LOCAL_REPO_DIR"

cat > /etc/yum.repos.d/rhtr-local.repo <<EOF
[rhtr-local]
name=RHTR Local Repository
baseurl=file://${LOCAL_REPO_DIR}
enabled=1
gpgcheck=0
EOF
dnf clean metadata &>/dev/null || true
