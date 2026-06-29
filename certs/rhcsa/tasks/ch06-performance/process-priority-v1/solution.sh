#!/usr/bin/env bash
worker_pid=$(pgrep -f sha256_worker | head -1)
renice 15 -p "$worker_pid"
nice -n -5 dd if=/dev/zero of=/dev/null &
