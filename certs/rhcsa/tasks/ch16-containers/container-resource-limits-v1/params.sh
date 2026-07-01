#!/usr/bin/env bash
CONTAINER_NAMES=(limitedapp boundedapp cappedapp)
MEMS_MB=(128 256 512)
CPUS=(0.5 1 1.5 2)

ic=$(( RANDOM % ${#CONTAINER_NAMES[@]} ))
im=$(( RANDOM % ${#MEMS_MB[@]} ))
icpu=$(( RANDOM % ${#CPUS[@]} ))

MEM_MB=${MEMS_MB[$im]}
CPU_VAL=${CPUS[$icpu]}

echo "CONTAINER_NAME=${CONTAINER_NAMES[$ic]}"
echo "MEM_LIMIT=${MEM_MB}m"
echo "MEM_BYTES=$(( MEM_MB * 1024 * 1024 ))"
echo "CPU_LIMIT=${CPU_VAL}"
echo "NANO_CPUS=$(python3 -c "print(int(${CPU_VAL} * 1000000000))")"
