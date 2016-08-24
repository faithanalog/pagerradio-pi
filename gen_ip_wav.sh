#!/bin/bash

if [[ $# < 3 ]]; then
    echo "Usage: $0 <device> <devname> <output>" 1>&2
    exit 1
fi

DEV="$1"
NAME="$2"
OUTPUT="$3"
IPCACHE="/tmp/current_ip_$DEV"

ip="$(ip addr show "$DEV" | grep 'inet ')"
if [[ -n "$ip" ]]; then
    #Extract ip address.
    ip="${ip##*inet }"
    ip="${ip%%/*}"

    #Get old ip address if it exists
    if [[ -f "$IPCACHE" ]]; then
        oldip="$(< "$IPCACHE")"
    else
        oldip=""
    fi

    if [[ "$ip" != "$oldip" ]]; then
        #Write old ip address to cache
        echo "$ip" > "$IPCACHE"

        #Convert to something like "1 0; dot; 0; dot; 0; dot; 1 8", so that the
        #text to speech reads it at the right speed.
        iptext="$(
            echo "$ip" \
                | sed -r 's/([[:digit:]])/\1 /g;
                          s/ \./; dot; /g'
        )"
        echo "$iptext"

        #Convert to a wave file, output to output file
        #Generates at a sample rate of 22050 Hz
        echo "$NAME address: $iptext" | text2wave -F 22050 > "$OUTPUT"
        #Add 0.5 seconds of padding, because otherwise the last number gets cut
        #off in transmission
        cat /dev/zero | head -c 22050 >> "$OUTPUT"
    fi
else
    echo "No IP address found for $DEV" 1>&2
    exit 1
fi
