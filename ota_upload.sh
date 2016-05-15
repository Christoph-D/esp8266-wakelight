#!/bin/bash
set -eu

MY_PATH="${0%/*}"

get_ip_from_lua() {
    local ip
    if ! [[ -s "$MY_PATH"/src/globals.lua ]] || \
            ! ip=$(grep '^WIFI_STATIC_IP' "$MY_PATH"/src/globals.lua 2>/dev/null); then
        echo 'Please rename src/globals.lua.template to src/globals.lua and set WIFI_STATIC_IP.' >&2
        echo 'Alternatively, you can set WAKELIGHT_IP in this script manually.' >&2
        exit 1
    fi
    ip=${ip#*\"}
    ip=${ip%%\"*}
    printf '%s' "$ip"
}

WAKELIGHT_IP=$(get_ip_from_lua) || exit $?

printf 'Wakelight IP: %s\n' "$WAKELIGHT_IP"

for f in "$@"; do
    if [[ ! -e "$f" ]]; then
        echo "Error: Cannot find $f" >&2
        exit 1
    fi
done

connect() {
    nc "$WAKELIGHT_IP" 80
}

for f in "$@"; do
    { printf "ESP8266UPLOAD %s " "${f##*/}" ; cat "$f"; } | connect
done

echo "ESP8266RESET" | connect
