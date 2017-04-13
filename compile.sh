#!/bin/bash

dir=$(dirname $0)

framerate=10

last_timestamp=$(ls capture | tail -n1 | grep -oE '\d+')

function gif() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -vf scale=320:-1 \
        "$dir/output/$last_timestamp-$framerate.gif"
}

# This doesn't quite work
function twitter() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -vcodec libx264 \
        -acodec aac \
        -vb 10000k \
        -bufsize 1024k \
        -ar 44100 -strict experimental \
        "$dir/output/$last_timestamp-$framerate-twitter.mp4"

        # -vb 1024k -minrate 1024k -maxrate 1024k \
        # -vf 'scale=640:trunc(ow/a/2)*2' \
}

# instagram
function instagram() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -vcodec mpeg4 -vb 10000k \
        "$dir/output/$last_timestamp-$framerate-instagram.mp4"
}

# rm capture/*

gif
instagram
