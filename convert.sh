#!/bin/bash

function help() {
    echo "Convert video into frames"
    echo
    echo "Options:"
    echo "-h    Show this help info and quit"
    echo "-i    Input video path (required)"
    echo "-r    Frame rate (default: 12)"
    echo
    echo "Usage:"
    echo "$0 -h"
}

input=
framerate=12

mkdir -p capture

while getopts "h?i:r:" opt; do
    case "$opt" in
        h) help; exit ;;
        i) input="$OPTARG" ;;
        r) framerate="$OPTARG" ;;
        *) help; exit ;;
    esac
done

if [[ -z "$input" ]]; then
    echo 'No input path found'
    exit 1
fi

dir=$(dirname "$0")

function cleanup() {
    count=$(find capture/* | wc -l | xargs)

    if [[ "$count" != "0" ]]; then
        echo "Found $count preexisting captures. Delete them first? [y/N] "

        read -r
        if [[ "$REPLY" =~ ^(yes|y|Y)$ ]]; then
            rm capture/*
        fi
    fi
}

cleanup

ffmpeg \
    -i "$input" \
    -r "$framerate" \
     -q:v 1 -qmin 1 -qmax 1  \
    "$dir/capture/%03d.jpg"
