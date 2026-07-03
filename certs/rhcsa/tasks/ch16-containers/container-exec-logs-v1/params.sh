#!/usr/bin/env bash
MARKERS=(rhtr_exec_marker1.txt rhtr_exec_marker2.txt rhtr_exec_marker3.txt)
OUTFILES=(/root/container-logs1.txt /root/container-logs2.txt /root/container-logs3.txt)
i=$(( RANDOM % ${#MARKERS[@]} ))
echo "MARKER_FILE=${MARKERS[$i]}"
echo "OUTPUT_FILE=${OUTFILES[$i]}"
