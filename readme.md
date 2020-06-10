Shell scripts for capturing and compiling timelapse photography, like this:

![Example timelapse output](http://tommy.sh/timelapse/example-10-064.gif)

## Requirements

### Software

- [ffmpeg](https://www.ffmpeg.org/)
- [gifsicle](https://www.lcdf.org/gifsicle/) (optional)

### Hardware

- An iPhone or webcam with a live JPG photo URL

Because my phone is the best camera I own, I use it plus the [ipCamera](https://itunes.apple.com/us/app/ipcamera-high-end-network/id570912928?mt=8) app; its undocumented photo URL path is `/photo`. To get it in the right physical position, I have a [cheap gooseneck phone holder](https://smile.amazon.com/Gooseneck-BESTEK-Bracket-Bedroom-Bathroom/dp/B00JK70KUY/ref=sr_1_9?s=electronics&ie=UTF8&qid=1514506711&sr=1-9&keywords=gooseneck+iphone+holder). Scrappy!

## Installation

For Mac with [Homebrew](https://brew.sh/):

    brew install ffmpeg
    brew install gifsicle
    brew install imagemagick

## Usage

First run `capture.sh` by passing it the URL:

    ./capture.sh -u http://127.0.0.1:8080/capture

This script will run forever, so press `ctrl+c` when want to quit.

Next, run `compile.sh`:

    ./compile.sh

That will put an MP4 video and myriad smaller GIFs in the `output` folder.

When it's done, it will ask if you want to delete the captured photos. Maybe verify the output is acceptable before letting it do that!

### Options and help

For a full list of the optional arguments, pass `-h` to either script:

    ./capture.sh -h
    ./compile.sh -h

## License

MIT license or as components allow
