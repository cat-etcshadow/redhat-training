#!/usr/bin/env bash
SWAPFILES=(/swapfile /swap.img /opt/rhtr_swapfile)
SIZES=(256 384 512)
i=$(( RANDOM % ${#SWAPFILES[@]} ))
s=$(( RANDOM % ${#SIZES[@]} ))
echo "SWAP_FILE=${SWAPFILES[$i]}"
echo "SWAP_SIZE_MB=${SIZES[$s]}"
