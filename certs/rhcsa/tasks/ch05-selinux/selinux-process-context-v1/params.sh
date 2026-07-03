#!/usr/bin/env bash
OUTS=(rhtr_proc_ctx1.txt rhtr_proc_ctx2.txt rhtr_proc_ctx3.txt)
i=$(( RANDOM % ${#OUTS[@]} ))
echo "OUTPUT_FILE=/opt/${OUTS[$i]}"
