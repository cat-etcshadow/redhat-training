#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

SSH_DIR="/home/${SSH_USER}/.ssh"
PRIV_KEY="${SSH_DIR}/id_rsa"
PUB_KEY="${SSH_DIR}/id_rsa.pub"
AUTH_KEYS="${SSH_DIR}/authorized_keys"

[[ -d "$SSH_DIR" ]]   || fail "$SSH_DIR directory does not exist"
[[ -f "$PRIV_KEY" ]]  || fail "private key $PRIV_KEY does not exist"
[[ -f "$PUB_KEY" ]]   || fail "public key $PUB_KEY does not exist"
[[ -f "$AUTH_KEYS" ]] || fail "$AUTH_KEYS does not exist"

# correct permissions
ssh_dir_perm=$(stat -c '%a' "$SSH_DIR")
[[ "$ssh_dir_perm" == "700" ]] \
  || fail "$SSH_DIR has permissions $ssh_dir_perm, expected 700"

auth_perm=$(stat -c '%a' "$AUTH_KEYS")
[[ "$auth_perm" == "600" ]] \
  || fail "$AUTH_KEYS has permissions $auth_perm, expected 600"

# ownership
owner=$(stat -c '%U' "$SSH_DIR")
[[ "$owner" == "$SSH_USER" ]] \
  || fail "$SSH_DIR owned by $owner, expected $SSH_USER"

# public key must be in authorized_keys
pub_content=$(cat "$PUB_KEY")
grep -qF "$pub_content" "$AUTH_KEYS" \
  || fail "public key content not found in $AUTH_KEYS"

# functional test: passwordless SSH to localhost
result=$(su - "$SSH_USER" -c \
  "ssh -o StrictHostKeyChecking=no -o BatchMode=yes \
       -i ${PRIV_KEY} ${SSH_USER}@localhost whoami 2>/dev/null") \
  || fail "passwordless SSH as $SSH_USER to localhost failed"
[[ "$result" == "$SSH_USER" ]] \
  || fail "ssh whoami returned '$result', expected '$SSH_USER'"

# sshd must have PubkeyAuthentication yes
grep -qiE '^\s*PubkeyAuthentication\s+yes' /etc/ssh/sshd_config \
  || fail "sshd_config: PubkeyAuthentication is not set to yes"

[[ $errors -eq 0 ]] && exit 0 || exit 1
