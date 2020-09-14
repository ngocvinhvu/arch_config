XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME
export $(dbus-launch)
ibus-daemon -drx
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT4_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"


# export _JAVA_AWT_WM_NONREPARENTING=1

# From .zshrc
export PATH="$PATH:$HOME/.rvm/bin:$HOME/.local/bin:$HOME/.gem/ruby/2.7.0/bin:$HOME/gits/arch_config/scripts:$HOME/gits/arch_config/.local/bin/statusbar:$HOME/.cargo/bin"

# setxkbmap -option ctrl:swapcaps

sudo sh -c "echo 10   >  /sys/devices/platform/i8042/serio1/serio2/drift_time"       # default 5 
sudo sh -c "echo 200 > /sys/devices/platform/i8042/serio1/serio2/sensitivity"     # default 128
sudo sh -c "echo 120 > /sys/devices/platform/i8042/serio1/serio2/speed"           # default 97

export VISUAL=vim
export EDITOR=$VISUAL
export BROWSER=/usr/bin/qutebrowser
export SHELL=/bin/bash

# ./.fehbg
[ ! -e ~/.config/mpd/pid ] && mpd
# sh -c mpd > /dev/null
# ./.config/polybar/launch_polybar > /dev/null 2>&1 

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export LF_ICONS="di=:\
fi=📃:\
tw=🤝:\
ow=:\
ln=:\
or=❌:\
ex=🎯:\
*.txt=✍:\
*.mom=✍:\
*.me=✍:\
*.ms=✍:\
*.png=🖼:\
*.webp=🖼:\
*.ico=🖼:\
*.jpg=📸:\
*.jpe=📸:\
*.jpeg=📸:\
*.gif=🖼:\
*.svg=🗺:\
*.tif=🖼:\
*.tiff=🖼:\
*.xcf=🖌:\
*.html=🌎:\
*.xml=📰:\
*.gpg=🔒:\
*.css=:\
*.pdf=:\
*.djvu=📚:\
*.epub= :\
*.csv= :\
*.xlsx= :\
*.docx=:\
*.doc=:\
*.tex=📜:\
*.md= :\
*.r=📊:\
*.R=📊:\
*.rmd=📊:\
*.Rmd=📊:\
*.m=📊:\
*.mp3=♬:\
*.opus=♬:\
*.ogg=♬:\
*.m4a=♬:\
*.flac= :\
*.mkv= :\
*.mp4=🎬:\
*.webm=🎬:\
*.mpeg=🎬:\
*.avi=🎬:\
*.zip=📦:\
*.rar=📦:\
*.7z=📦:\
*.tar.gz=📦:\
*.z64=🎮:\
*.v64=🎮:\
*.n64=🎮:\
*.gba=🎮:\
*.nes=🎮:\
*.gdi=🎮:\
*.1= :\
*.nfo= :\
*.info= :\
*.log=📙:\
*.iso=:\
*.img=:\
*.bib=🎓:\
*.ged=👪:\
*.part=💔:\
*.torrent= :\
*.jar=♨:\
*.java=♨:\
"
