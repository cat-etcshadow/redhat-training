#!/usr/bin/env bash
POOL=(750 640 600 644 700 664)
shuffled=($(printf '%s\n' "${POOL[@]}" | shuf))

echo "APP_DIR=/opt/rhtr-deploy"
echo "FILE1=deploy.sh"
echo "MODE1=${shuffled[0]}"
echo "FILE2=config.ini"
echo "MODE2=${shuffled[1]}"
echo "FILE3=secrets.env"
echo "MODE3=${shuffled[2]}"
echo "FILE4=readme.txt"
echo "MODE4=${shuffled[3]}"
