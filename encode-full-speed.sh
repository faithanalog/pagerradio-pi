#!/bin/bash

# This script is useful for generating output st full speed when using the 
# output WAV as audio, say to a "real" FM transmitter such as:
# https://www.amazon.com/gp/product/B018QN4INM/

# https://github.com/faithanalog/pagerenc
MESSAGE_ENCODER=pagerenc

if [[ $# < 2 ]]; then
    echo "Usage: $0 <messagefile> <outfile>" 1>&2
else
    #Inverts audio, and slows down to speed of 0.991
    #We use cat here since it handles '-' properly for stdin
    cat "$1" \
        | "$MESSAGE_ENCODER" \
        | ffmpeg -loglevel 16 -f s16le -ar 22050 -ac 1 -i - -af 'volume=-0.75' -f wav - \
        | sox -V1 -t wav - -t wav "$2"
fi
