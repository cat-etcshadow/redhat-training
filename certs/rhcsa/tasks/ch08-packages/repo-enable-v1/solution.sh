#!/usr/bin/env bash
repo_file=$(grep -rl '^\[extras\]' /etc/yum.repos.d/ | head -1)
sed -i 's/^enabled=0/enabled=1/' "$repo_file"
