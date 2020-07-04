XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME
export $(dbus-launch)
ibus-daemon -drx
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT4_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"

export _JAVA_AWT_WM_NONREPARENTING=1

# From .zshrc
export PATH="$PATH:$HOME/.rvm/bin:$HOME/.local/bin:$HOME/.gem/ruby/2.7.0/bin:$HOME/gits/arch_config/scripts:$HOME/gits/arch_config/.local/bin/statusbar"

# setxkbmap -option ctrl:swapcaps

sudo sh -c "echo 10   >  /sys/devices/platform/i8042/serio1/serio2/drift_time"       # default 5 
sudo sh -c "echo 200 > /sys/devices/platform/i8042/serio1/serio2/sensitivity"     # default 128
sudo sh -c "echo 120 > /sys/devices/platform/i8042/serio1/serio2/speed"           # default 97

export VISUAL=vim
export EDITOR=$VISUAL
export BROWSER=/usr/bin/qutebrowser

# ./.fehbg
[ ! -e ~/.config/mpd/pid ] && mpd
# sh -c mpd > /dev/null
# ./.config/polybar/launch_polybar > /dev/null 2>&1 

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
