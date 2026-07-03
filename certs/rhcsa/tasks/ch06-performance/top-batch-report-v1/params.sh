#!/usr/bin/env bash
OUTS=(rhtr_top_snapshot1.txt rhtr_top_snapshot2.txt rhtr_top_snapshot3.txt)
i=$(( RANDOM % ${#OUTS[@]} ))
echo "OUTPUT_FILE=/opt/${OUTS[$i]}"
