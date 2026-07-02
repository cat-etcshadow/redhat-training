#!/usr/bin/env bash
PAIRS=("tree bc" "tmux mtr" "mtr tree" "bc tmux")
i=$(( RANDOM % ${#PAIRS[@]} ))
pair=(${PAIRS[$i]})

echo "PKG_A=${pair[0]}"
echo "PKG_B=${pair[1]}"
