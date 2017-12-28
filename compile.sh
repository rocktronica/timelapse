#!/bin/bash

dir=$(dirname "$0")

framerate=10

last_timestamp=$(find capture/*.jpg | tail -n1 | grep -oE '\d+')

function gif() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -vf scale=320:-1 \
        "$dir/output/$last_timestamp-$framerate.gif"
}

function twitter() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -movflags faststart \
        -pix_fmt yuv420p \
        "$dir/output/$last_timestamp-$framerate-twitter.mp4"
}

function instagram() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -vcodec mpeg4 -vb 10000k \
        "$dir/output/$last_timestamp-$framerate-instagram.mp4"
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
twitter
instagram

cleanup
