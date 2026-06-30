#!/usr/bin/env bash
useradd -m "$UMASK_USER" 2>/dev/null || true
echo "umask $UMASK_VAL" >> "/home/$UMASK_USER/.bash_profile"
cat > /etc/profile.d/custom-umask.sh <<EOF
umask $UMASK_VAL
EOF
