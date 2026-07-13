#!/usr/bin/env bash
chage -m "$MIN_AGE" -M "$MAX_AGE1" -W "$WARN_DAYS" -I "$INACTIVE" "$USER1"
chage -d 0 -M "$MAX_AGE2" "$USER2"
