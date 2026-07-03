#!/usr/bin/env bash
su - "$TARGET_USER" -c '{ whoami; pwd; } > ~/confirmed.txt'
