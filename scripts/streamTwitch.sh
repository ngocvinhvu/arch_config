ffmpeg -f x11grab -video_size 1600x900 -i :0 -c:v libx264 -preset ultrafast -f flv "rtmp://live.twitch.tv/app/$*"
