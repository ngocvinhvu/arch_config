#!/usr/bin/sh
mpv --no-audio --border --video-unscaled --wid=0 --loop-file=inf --speed=1.0 $1 > /dev/null 2>&1
