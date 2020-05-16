ffmpeg -f x11grab -s 1600x900 -r 24 -i :0 -deinterlace -stream_loop -1 -i ~/Music/curtainCall/Eminem\ -\ FACK.mp3  -f flv  "rtmp://a.rtmp.youtube.com/live2/$*" -c:v libx264 
