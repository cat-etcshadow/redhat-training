#!/usr/bin/env bash
su - student -c "
set -e
git clone $BARE_REPO $CLONE_DIR
cd $CLONE_DIR
git config user.email student@example.com
git config user.name student
echo '---' > $NEW_FILE
echo '- hosts: all' >> $NEW_FILE
echo '  tasks: []' >> $NEW_FILE
git add $NEW_FILE
git commit -q -m 'Add $NEW_FILE'
git push -q origin main
"
