#!/usr/bin/env bash
sed -i 's#/usr/local/bin/rhtr-brokensvc-typo.sh#/usr/local/bin/rhtr-brokensvc.sh#' \
  /etc/systemd/system/rhtr-brokensvc.service
systemctl daemon-reload
systemctl restart rhtr-brokensvc.service
