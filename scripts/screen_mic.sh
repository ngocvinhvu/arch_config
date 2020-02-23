yes | ffmpeg -f x11grab -video_size 1600x900 -i :0  -f pulse -i default ~/screen_mic.mkv
