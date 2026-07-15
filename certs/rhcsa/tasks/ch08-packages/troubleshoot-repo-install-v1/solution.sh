#!/usr/bin/env bash
# investigate:
# dnf install -y tree
# dnf repolist all
# cat /etc/yum.repos.d/rhtr-internal.repo
sed -i 's/^enabled=1/enabled=0/' /etc/yum.repos.d/rhtr-internal.repo
dnf clean expire-cache &>/dev/null
