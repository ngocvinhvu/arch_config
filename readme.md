add: 
    set ranger_load_default_rc false >> rc.conf

add:
    mime ^image/gif, has mpv,     X, flag f = mpv --loop=0 -- "$@" >> rifle.conf
