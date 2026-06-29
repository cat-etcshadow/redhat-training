#!/usr/bin/env bash
grep -ri 'error' "$LOG_DIR" > "$ERROR_OUTPUT"
grep -rE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' "$LOG_DIR" > "$IP_OUTPUT"
