# pagerradio-pi

Broadcasts pager messages over normal radio frequencies, much like a short-range
radio which you'd plug into your phone for use in a car. Also broadcasts the IP
address of your pi to make it easier to access if it's headless and using a
dynamic IP.


# ! Important ! Will not work on a pi3!

pifm, and by extension this project, will not work on a raspberry pi 3. It is
unknown if it will work on a pi2, but any other raspberry pi derivative (A, B,
B+, zero) should work.


# Install & Usage

1. Make sure your pi is running Raspbian Jessie.

2. Install pifm from https://github.com/faithanalog/pifm.

3. `sudo apt install festival` to install text-to-speech.

4. Clone this directory to /root/pager on your pi.

5. Copy pagerradio.service to /etc/systemd/system/pagerradio.service.

6. `sudo systemctl enable pagerradio` to run automatically on boot.

7. Put your broadcast data in /home/pi/pager\_data.wav or modify `PAGER_FILE` in
   pager\_loop.sh to point to the right file.

8. Restart your pi.

9. Your pi should now be broadcasting the contents of pager\_data.wav on loop,
   with the IP address of your pi broadcast in between.


# Encoding messages

See encode.sh for details.


# Playing back recordings

pifm plays back audio slightly faster than the input wave file. To play back
recorded data, you must first slow it down to a speed of 0.991. This must be
done by resampling the audio; any method of changing the speed of audio which
leaves the pitch intact will not work! Additionally, audio will be broadcast
with the amplitude inverted.

Here is an example command using ffmpeg and sox to convert an audio file so that
it can be broadcast properly. This is the same method used by encode.sh.

    ffmpeg -i <input> -af 'volume=-0.75' -f wav - \
        | sox -t wav - <output> speed 0.991

Alternatively, if you wanted to transmit the resulting encoded WAV with a "real" FM transmitter (such as those used to connect audio devices to in-dash car stereo units) the speed does not need to be slowed down.  Using encode-full-speed.sh will output a non-speed corrected WAV file for use in these situations. 
