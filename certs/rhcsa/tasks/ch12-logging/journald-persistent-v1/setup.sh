#!/usr/bin/env bash
# Reset to volatile (default) storage. Deliberately does NOT rm -rf
# /var/log/journal — a sibling ch12 task (journalctl-vacuum-v1) seeds bulk
# content there so vacuuming is a real, measurable action, and grading here
# only checks the journald.conf Storage= line and service state, not that
# the directory is freshly empty — so there's nothing to gain from wiping it,
# and doing so was silently gutting journalctl-vacuum-v1 whenever this task's
# setup ran after it in the same session.
sed -i '/^Storage/d; /^SystemMaxUse/d' /etc/systemd/journald.conf
systemctl restart systemd-journald
