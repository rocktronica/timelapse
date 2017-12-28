#!/bin/bash

function help() {
    echo "Capture photos"
    echo
    echo "Options:"
    echo "-h    Show this help info and quit"
    echo "-u    Photo URL (required)"
    echo "-d    Seconds to delay between captures (default: 5)"
    echo
    echo "Usage:"
    echo "$0 -h"
    echo "$0 -u http://192.168.42.64/photo -d 1"
    echo
    echo "Press ctrl+c to quit"
}

url=
delay=5

while getopts "h?u:d:" opt; do
    case "$opt" in
        h) help; exit ;;
        u) url="$OPTARG" ;;
        d) delay="$OPTARG" ;;
    esac
done

if [[ -z "$url" ]]; then
    echo 'No URL found'
    exit 1
fi

dir=$(dirname "$0")

mkdir -p capture
mkdir -p output

while True; do
    timestamp="$(date +%s)"
    curl -# -L --max-time 10 \
        "$url" > "$dir/capture/$timestamp.jpg"
    sleep "$delay"
done
