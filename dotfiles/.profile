XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME
export $(dbus-launch)
ibus-daemon -drx
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT4_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"

# setxkbmap -option ctrl:swapcaps

sudo sh -c "echo 15 >  /sys/devices/platform/i8042/serio1/serio2/drift_time"
sudo sh -c "echo 200 > /sys/devices/platform/i8042/serio1/serio2/sensitivity"
# sudo sh -c "echo 150 > /sys/devices/platform/i8042/serio1/serio2/speed"

export VISUAL=vim
export EDITOR=$VISUAL
export BROWSER=/usr/bin/qutebrowser

# ./.fehbg
[ ! -s ~/.config/mpd/pid ] && mpd
# sh -c mpd > /dev/null
# ./.config/polybar/launch_polybar > /dev/null 2>&1 

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
