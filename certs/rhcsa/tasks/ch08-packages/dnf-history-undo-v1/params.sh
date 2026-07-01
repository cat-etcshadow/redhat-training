#!/usr/bin/env bash
PAIRS=("tree bc" "screen mtr" "mtr tree" "bc screen")
i=$(( RANDOM % ${#PAIRS[@]} ))
pair=(${PAIRS[$i]})

echo "PKG_A=${pair[0]}"
echo "PKG_B=${pair[1]}"
