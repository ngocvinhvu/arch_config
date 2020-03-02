XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME
export $(dbus-launch)
# setxkbmap -option ctrl:swapcaps
sudo sh -c "echo 15 >  /sys/devices/platform/i8042/serio1/serio2/drift_time"
sudo sh -c "echo 200 > /sys/devices/platform/i8042/serio1/serio2/sensitivity"
# sudo sh -c "echo 150 > /sys/devices/platform/i8042/serio1/serio2/speed"

export VISUAL=vim
export EDITOR=$VISUAL
export BROWSER=/usr/bin/firefox
./.fehbg
# [ ! -s ~/.config/mpd/pid ] && mpd
sh -c mpd > /dev/null
# ./.config/polybar/launch_polybar > /dev/null 2>&1 
