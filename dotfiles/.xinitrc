. ~/.profile
xmodmap ~/.Xmodmap
xrdb ~/.Xresources
# for dwm
while true
do
    xsetroot -name "[`date`][`cat /sys/class/power_supply/BAT0/status`:`cat /sys/class/power_supply/BAT0/capacity`][`echo VOL:``pamixer --get-volume-human`]"  # `uptime | sed 's/.*,//'`
        sleep 1
        done &
exec dwm

