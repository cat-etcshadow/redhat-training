#!/usr/bin/env bash
journalctl --vacuum-size="$VACUUM_CAP"
