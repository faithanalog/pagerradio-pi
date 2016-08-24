#!/bin/bash

PAGER_FILE="/home/pi/pager_data.wav"

#Associative array of all network devices for which we will broadcast IPs.
#Key is the device itself, and value is the broadcast name
declare -A NET_DEVICES
NET_DEVICES[eth0]=Ethernet
NET_DEVICES[wlan0]=Wireless

#Get the tts save file for a device
function ttsFile() {
    echo "/tmp/ip_tts_$1.wav"
}

#Broadcast the IP address of a device, generating the broadcast first if needed
function broadcastIP() {
    dev="$1"
    name="$2"
    file="$(ttsFile $dev)"
    ./gen_ip_wav.sh $dev $name "$file" &>/dev/null && pifm "$file" > /dev/null
}

#-- Execution Start --

#Cleanup from any previous runs
for dev in ${!NET_DEVICES[@]}; do
    rm -f "$(ttsFile $dev)"
done
rm -f /tmp/current_ip_*

while true; do
    for dev in ${!NET_DEVICES[@]}; do
        broadcastIP $dev "${NET_DEVICES[$dev]}"
    done
    pifm "$PAGER_FILE" > /dev/null
done
