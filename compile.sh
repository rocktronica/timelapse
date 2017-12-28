#!/bin/bash

function help() {
    echo "Assemble captured photos into timelapse"
    echo
    echo "Options:"
    echo "-h    Show this help info and quit"
    echo "-s    Filename slug (default: last photo)"
    echo "-r    Frame rate (default: 12)"
    echo "-w    Gif width (default: 320)"
    echo
    echo "Usage:"
    echo "$0 -h"
    echo "$0 -s FILENAME_SLUG -r 30 -w 600"
}

slug=$(find capture/*.jpg | tail -n1 | grep -oE '\d+')
framerate=12
gif_width=320

while getopts "h?s:r:w:" opt; do
    case "$opt" in
        h) help; exit ;;
        s) slug="$OPTARG" ;;
        r) framerate="$OPTARG" ;;
        w) gif_width="$OPTARG" ;;
    esac
done

dir=$(dirname "$0")

function gif() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -vf scale="$gif_width:-1" \
        "$dir/output/$slug-$framerate.gif"
}

function video() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -movflags faststart \
        -pix_fmt yuv420p \
        -vb 10000k \
        "$dir/output/$slug-$framerate.mp4"
}

function cleanup() {
    count=$(find capture/*.jpg | wc -l | xargs)

    echo
    echo "All done! Delete $count captured photos? [y/N] "

    read -r
    if [[ "$REPLY" =~ ^(yes|y|Y)$ ]]; then
        rm capture/*
    fi
}

gif
video

cleanup
