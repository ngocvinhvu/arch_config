ffmpeg -f v4l2 -video_size 640x480 -i /dev/video0 -f alsa -i pulse -c:v libx264 -preset ultrafast -c:a aac webcam.mp4
