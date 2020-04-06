yes | ffmpeg -f x11grab -video_size 1600x900 -i :0 -c:v libx264 -preset ultrafast ~/screen_only.mkv 2> /dev/null
