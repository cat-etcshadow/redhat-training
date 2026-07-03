#!/usr/bin/env bash
SCRIPTS=(rhtr_remote_report1.sh rhtr_remote_report2.sh rhtr_remote_report3.sh)
OUTS=(rhtr_ssh_out1.txt rhtr_ssh_out2.txt rhtr_ssh_out3.txt)
i=$(( RANDOM % ${#SCRIPTS[@]} ))
echo "REMOTE_SCRIPT=/opt/${SCRIPTS[$i]}"
echo "OUT_FILE=/opt/${OUTS[$i]}"
