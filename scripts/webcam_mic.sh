yes | ffmpeg -s 640x480 -i /dev/video0 -f pulse -i default  -c:v libx264 -preset ultrafast -c:a aac ~/webcam_mic.mkv
