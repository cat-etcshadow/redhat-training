#!/usr/bin/env bash
USERS=(alice bob carol dave erin frank)
OTHER_COUNTS=(3 5 7 9 11)

mkdir -p /var/log
: > "$LOG_FILE"

i=0
for u in "${USERS[@]}"; do
  if [[ "$u" == "$TOP_USER" ]]; then
    c=20
  else
    c=${OTHER_COUNTS[$(( i % ${#OTHER_COUNTS[@]} ))]}
    (( i++ ))
  fi
  for (( n=0; n<c; n++ )); do echo "$u" >> "$LOG_FILE"; done
done

shuf "$LOG_FILE" -o "$LOG_FILE"
rm -f "$OUTPUT_FILE"
