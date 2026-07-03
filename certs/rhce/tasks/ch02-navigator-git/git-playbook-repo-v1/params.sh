#!/usr/bin/env bash
REPOS=(playbooks automation-repo site-config)
FILES=(webserver.yml database.yml monitoring.yml)
idx=$(( RANDOM % ${#REPOS[@]} ))
fidx=$(( RANDOM % ${#FILES[@]} ))

echo "BARE_REPO=/srv/git/${REPOS[$idx]}.git"
echo "CLONE_DIR=/home/student/${REPOS[$idx]}"
echo "NEW_FILE=${FILES[$fidx]}"
