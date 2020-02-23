ffplay -s `xdpyinfo | grep 'dimensions:'| awk '{print  $2}'` -f x11grab -i :0 
