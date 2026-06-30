#!/usr/bin/env bash
dnf install -y at &>/dev/null
systemctl enable --now atd
at "now + $AT_DELAY minutes" <<EOF
echo "$AT_MESSAGE" > $AT_OUTFILE
EOF
