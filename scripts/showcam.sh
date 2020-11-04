#!/usr/bin/sh
# mpv av://v4l2:/dev/video0 --profile=low-latency --audio-file av://pulse:name-of-your-device # specify resolution
mpv --vf=hflip av://v4l2:/dev/video0 --profile=low-latency
