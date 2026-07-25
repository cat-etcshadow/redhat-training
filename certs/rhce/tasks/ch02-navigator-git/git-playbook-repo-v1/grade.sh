#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -d "$CLONE_DIR/.git" ]] || fail "$CLONE_DIR is not a git clone"
[[ -f "$CLONE_DIR/$NEW_FILE" ]] || fail "$NEW_FILE not found in $CLONE_DIR"

if [[ -d "$CLONE_DIR/.git" ]]; then
  git -C "$CLONE_DIR" log --name-only 2>/dev/null | grep -q "$NEW_FILE" \
    || fail "$NEW_FILE was not committed in $CLONE_DIR"
fi

git --git-dir="$BARE_REPO" log --name-only 2>/dev/null | grep -q "$NEW_FILE" \
  || fail "$NEW_FILE was not pushed to origin ($BARE_REPO)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
