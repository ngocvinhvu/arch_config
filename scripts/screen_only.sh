yes | ffmpeg -f x11grab -video_size 1920x1080 -i :0 -c:v libx264 -preset ultrafast ~/.trash/"`date "+%Y%b%d(%a)%I:%M%p"`_screen_only.mkv" 2> /dev/null
