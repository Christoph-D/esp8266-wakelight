#!/bin/bash
set -eu

cd "${0%/*}"

NODEMCU_UPLOADER='./nodemcu-uploader/nodemcu-uploader.py'
NODEMCU_UPLOADER_GIT='https://github.com/kmpm/nodemcu-uploader'

if [[ ! -s "$NODEMCU_UPLOADER" ]]; then
    echo "Fetching nodemcu-uploader..."
    git clone "$NODEMCU_UPLOADER_GIT"
fi
if [[ ! -s "$NODEMCU_UPLOADER" ]]; then
    echo "Something went wrong."
    echo "Please make sure $NODEMCU_UPLOADER exists."
    exit 1
fi

python "$NODEMCU_UPLOADER" --port /dev/ttyUSB${1-0} --baud 115200 \
       upload --compile --restart src/*.lua
