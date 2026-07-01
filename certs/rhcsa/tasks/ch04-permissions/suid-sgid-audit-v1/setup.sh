#!/usr/bin/env bash
rm -rf "$APP_DIR" "$REPORT_FILE"
mkdir -p "$APP_DIR"

for f in "$GOOD_BINARY" "$BAD_BINARY"; do
  printf '#!/usr/bin/env bash\ntrue\n' > "$APP_DIR/$f"
  chmod 4755 "$APP_DIR/$f"
done

for f in readme.txt run.sh; do
  printf '#!/usr/bin/env bash\ntrue\n' > "$APP_DIR/$f"
  chmod 755 "$APP_DIR/$f"
done
