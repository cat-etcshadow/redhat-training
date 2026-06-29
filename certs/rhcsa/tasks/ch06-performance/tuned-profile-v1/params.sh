#!/usr/bin/env bash
PROFILES=(throughput-performance latency-performance balanced powersave virtual-guest)
# Don't pick virtual-guest as target if that's the reset state in setup.sh —
# all 5 are valid candidates; setup resets to a different one anyway.
idx=$(( RANDOM % ${#PROFILES[@]} ))
echo "TUNED_PROFILE=${PROFILES[$idx]}"
