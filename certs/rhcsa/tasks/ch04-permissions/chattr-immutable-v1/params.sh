#!/usr/bin/env bash
FILES=(/etc/rhtr_critical1.conf /etc/rhtr_critical2.conf /etc/rhtr_critical3.conf)
i=$(( RANDOM % ${#FILES[@]} ))
echo "PROTECTED_FILE=${FILES[$i]}"
