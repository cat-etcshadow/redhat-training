#!/usr/bin/env bash
VGS=(vg_small vg_tight vg_limited)
i=$(( RANDOM % ${#VGS[@]} ))
echo "VG_NAME=${VGS[$i]}"
