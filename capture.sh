#!/bin/bash

delay=1
url='http://192.168.42.64/photo'

dir=$(dirname $0)

mkdir -p capture
mkdir -p output

while True; do
    timestamp="$(date +%s)"
    curl -# -L --max-time 10 "$url" > "capture/$timestamp.jpg"
    sleep 5
done
