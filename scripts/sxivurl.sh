#!/bin/sh
[ -f *.log ] && rm /tmp/*.log
sxiv -b `ls -t /tmp/*.*g`
