#!/usr/bin/env bash
job_id=""
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  jid=$(awk '{print $1}' <<< "$line")
  if at -c "$jid" 2>/dev/null | grep -q "$REMOVE_FILE"; then
    job_id="$jid"
    break
  fi
done <<< "$(atq)"

atrm "$job_id"
