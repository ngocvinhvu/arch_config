yes | ffmpeg  -f x11grab -video_size 1600x900 -i :0 -f pulse -i 0 ~/screen_audio.mkv
