#!/usr/bin/env bash
pkill rhtr_alpha 2>/dev/null || true
killall rhtr_beta 2>/dev/null || true
kill "$(cat /tmp/rhtr_kill_pid)" 2>/dev/null || true
