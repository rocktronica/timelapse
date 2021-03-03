#!/bin/bash

function help() {
    echo "Assemble captured photos into timelapse"
    echo
    echo "Options:"
    echo "-h    Show this help info and quit"
    echo "-s    Filename slug (default: last photo)"
    echo "-r    Frame rate (default: 12)"
    echo "-w    Gif width (default: 320)"
    echo "-d    Prompt to delete capture files when done (default: false)"
    echo "-b    Boomerang loop GIF (default: false)"
    echo
    echo "Usage:"
    echo "$0 -h"
    echo "$0 -s FILENAME_SLUG -r 30 -w 600"
}

slug=$(find capture/*.jpg | tail -n1 | grep -oE '\d+')
framerate=12
gif_width=320
delete=false
boomerang=false

while getopts "h?s:r:w:db" opt; do
    case "$opt" in
        h) help; exit ;;
        s) slug="$OPTARG" ;;
        r) framerate="$OPTARG" ;;
        w) gif_width="$OPTARG" ;;
        d) delete=true ;;
        b) boomerang=true ;;
        *) help; exit ;;
    esac
done

dir=$(dirname "$0")
filename="$dir/output/$slug-$framerate"

mkdir -p output

function gif() {
    if $boomerang; then
        _filename="$filename-boomerang"
    else
        _filename="$filename"
    fi

    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -vf scale="$gif_width:-1" \
        "$_filename.gif"

    if $boomerang; then
        convert "$_filename.gif" -coalesce -duplicate 1,-2-1 \
            -quiet -layers OptimizePlus -loop 0 "$_filename.gif"
    fi

    if hash gifsicle 2>/dev/null; then
        gifsicle -O3 --colors 256 < "$_filename.gif" > "$_filename-256.gif"
        gifsicle -O3 --colors 128 < "$_filename.gif" > "$_filename-128.gif"
        gifsicle -O3 --colors 64 < "$_filename.gif" > "$_filename-064.gif"
        gifsicle -O3 --colors 32 < "$_filename.gif" > "$_filename-032.gif"
    else
        echo "gifsicle not found. Not running extra compression."
    fi
}

function video() {
    ffmpeg \
        -r "$framerate" \
        -pattern_type glob -i "$dir/capture/*.jpg" \
        -movflags faststart \
        -pix_fmt yuv420p \
        -vb 10000k \
        "$filename.mp4"
}

function cleanup() {
    count=$(find capture/*.jpg | wc -l | xargs)

    echo
    read -p "All done! Delete $count captured photos? [Y/n] " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Y]$ ]]; then
        echo "rm capture/*"
    else
        exit
    fi
}

gif
video

if $delete; then
    cleanup
fi
