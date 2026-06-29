#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$HARD_LINK" ]] || fail "hard link $HARD_LINK does not exist"
[[ -L "$SOFT_LINK" ]] || fail "symbolic link $SOFT_LINK does not exist or is not a symlink"

# hard link: same inode as target
inode_target=$(stat -c '%i' "$TARGET_FILE")
inode_hard=$(stat -c '%i' "$HARD_LINK")
[[ "$inode_target" == "$inode_hard" ]] \
  || fail "hard link $HARD_LINK has inode $inode_hard but $TARGET_FILE has inode $inode_target"

# hard link: link count must be >= 2
nlinks=$(stat -c '%h' "$TARGET_FILE")
(( nlinks >= 2 )) || fail "$TARGET_FILE link count is $nlinks (expected >= 2)"

# soft link: points to correct target
link_dest=$(readlink "$SOFT_LINK")
[[ "$link_dest" == "$SOFT_TARGET" ]] \
  || fail "symlink $SOFT_LINK points to '$link_dest', expected '$SOFT_TARGET'"

# soft link: resolves and is readable
[[ -r "$SOFT_LINK" ]] || fail "symlink $SOFT_LINK is broken (target not readable)"

# hard link shares data: append via hard link, visible in original
echo "grader-test-line" >> "$HARD_LINK"
grep -q 'grader-test-line' "$TARGET_FILE" \
  || fail "write via hard link not visible in $TARGET_FILE — not a true hard link"

[[ $errors -eq 0 ]] && exit 0 || exit 1
