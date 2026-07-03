#!/usr/bin/env bash
CANDIDATES=("bc:/usr/bin/bc" "nmap-ncat:/usr/bin/nc" "lsof:/usr/bin/lsof")
i=$(( RANDOM % ${#CANDIDATES[@]} ))
IFS=':' read -r PKG BIN_PATH <<< "${CANDIDATES[$i]}"
echo "PKG=${PKG}"
echo "BIN_PATH=${BIN_PATH}"
