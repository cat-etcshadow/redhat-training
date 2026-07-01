#!/usr/bin/env bash
userdel -r "$SVC_USER" 2>/dev/null || true
rm -rf "$SVC_HOME"
