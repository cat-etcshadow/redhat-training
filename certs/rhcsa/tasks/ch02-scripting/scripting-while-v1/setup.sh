#!/usr/bin/env bash
rm -f "$SCRIPT_PATH"
# pre-create one user so the SKIP branch is exercised
useradd -M rhtr_wh_alice 2>/dev/null || true
# remove users that should be created fresh
for u in rhtr_wh_bob rhtr_wh_carol rhtr_wh_dave; do
  userdel -r "$u" 2>/dev/null || true
done
cat > "$INPUT_FILE" <<'EOF'
rhtr_wh_alice
rhtr_wh_bob
rhtr_wh_carol
rhtr_wh_dave
EOF
