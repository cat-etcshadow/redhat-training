#!/usr/bin/env bash
# investigate:
# top -bn1 | head -15
# ps -eo pid,pcpu,cmd --sort=-pcpu | head
pkill -f rhtr-hog.sh
