xmodmap ~/.Xmodmap
. ~/.profile
xrdb ~/.Xresources
slstatus >/dev/null 2>&1 &
exec dwm
