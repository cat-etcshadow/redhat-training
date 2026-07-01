#!/usr/bin/env bash
# Kill any previous instances
pkill -f sha256_worker 2>/dev/null || true
pkill -f "dd if=/dev/zero" 2>/dev/null || true
# Start a low-priority background worker with default nice.
# Redirect all I/O away from the PTY so incus exec returns immediately.
bash -c 'while true; do echo sha256_worker | sha256sum > /dev/null; done' </dev/null >/dev/null 2>&1 &
WORKER_PID=$!
disown $WORKER_PID
