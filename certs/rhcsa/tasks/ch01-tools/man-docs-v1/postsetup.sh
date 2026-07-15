#!/usr/bin/env bash
# Snapshot /etc/hosts after every task's own setup.sh has run — other tasks
# in the exam (e.g. hostname-dns-v1) mutate /etc/hosts from their own
# setup.sh, which can run after this task's setup.sh already executed.
# grading must compare against this baseline, not against /etc/hosts as it
# stood mid-setup or as it stands at grading time.
cp -a /etc/hosts /root/.rhtr-hosts-snapshot
