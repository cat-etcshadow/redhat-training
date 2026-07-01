#!/usr/bin/env bash
NAMES=(gwatson hpierce ldavis tmoore rcollins)
shuf_names=($(printf '%s\n' "${NAMES[@]}" | shuf))

echo "LOCK_USER=${shuf_names[0]}"
echo "UNLOCK_USER=${shuf_names[1]}"
