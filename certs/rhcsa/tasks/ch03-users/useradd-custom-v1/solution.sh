#!/usr/bin/env bash
useradd -r -M -d "$SVC_HOME" -s /sbin/nologin -c "$SVC_COMMENT" "$SVC_USER"
