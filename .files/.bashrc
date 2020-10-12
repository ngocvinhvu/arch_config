#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l --color=auto --group-directories-first'
alias l='ls -a --color=auto --group-directories-first'
alias la='ls -la --color=auto --group-directories-first'
# PS1='\e[0;34m\u\e[m@\e[0;33m\h\e[m:\e[0;32m$PWD\e[m\n\$ '
PS1='\e[0;34m`date '+%r'`:\e[0;32m$PWD\e[m\n\$ '
PS2='>>> '
echo -ne '\e[4 q' # Cursor is underscore instead of Block


# Customize
# set -o vi

# Bind field
# bind 'TAB:menu-complete'
# bind '"jk":vi-movement-mode'
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-command 'u: undo'
# bind -m vi-command '/: vi-search'
bind -m vi-insert '"jk":vi-movement-mode'
bind -m vi-insert 'Control-l: clear-screen'
bind -m vi-insert 'TAB: menu-complete'
bind -m vi-insert '"\e[Z": menu-complete-backward'
bind -m vi-insert 'Control-e: edit-and-execute-command'


# export field
export HISTFILE=~/.bash_history
export HISTSIZE=99999
# export HISTCONTROL=ignoreboth:erasedups
export HISTCONTROL=ignoreboth
export SAVEHIST=$HISTSIZE
# color for manpage
# export LESS_TERMCAP_mb=$'\e[1;32m' # light yellow
# export LESS_TERMCAP_md=$'\e[1;32m'
# export LESS_TERMCAP_me=$'\e[0m'
# export LESS_TERMCAP_se=$'\e[0m'
# export LESS_TERMCAP_so=$'\e[01;31m' # red # search
# export LESS_TERMCAP_ue=$'\e[0m'
# export LESS_TERMCAP_us=$'\e[1;4;33m' # dark yellow
export FZF_DEFAULT_COMMAND="find -L"


# alias field
alias openvpn='sudo openvpn --config'
alias msfconsole="msfconsole --quiet -x \"db_connect nnd@msf\""
alias emacs="emacs -nw"
alias pscpu="ps -eo pid,cmd,%mem,%cpu --sort=-%cpu| less"
alias psmem="ps -eo pid,cmd,%mem,%cpu --sort=-%mem| less"
alias vi="vim -u NONE"
alias youtube-dl="youtube-dl --write-auto-sub --external-downloader aria2c --external-downloader-args '-c -j 3 -x 3 -s 3 -k 1M'"
alias emoji="cat ~/gits/arch_config/.local/share/larbs/emoji"
alias lsf="ls -ap | grep -v '/'"
alias lsd="la -p | grep '/'"
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias p='cd /home/duy/gits/python'
alias t='cd /home/duy/.trash'
alias a='cd /home/duy/gits/arch_config'
alias start='sudo systemctl start'
alias restart='sudo systemctl restart'
alias status='sudo systemctl status'
alias stop='sudo systemctl stop'
alias wifi='sudo wifi-menu wlp3s0'
alias wifi-menu='sudo wifi-menu'
alias rst='sudo netctl stop-all && sudo netctl start wlp3s0-Tenda_106570'
alias rstt='sudo netctl stop-all && sudo netctl start wlp3s0-TP-Link_73B6'
alias rsa='sudo netctl stop-all && sudo netctl start wlp3s0-abc.xyz'
alias rsn='sudo netctl stop-all && sudo netctl start wlp3s0-nguyenngocanh'
# alias rst="connmanctl connect wifi_100ba9094cfc_54656e64615f313036353730_managed_psk"
# alias rsa="connmanctl connect wifi_100ba9094cfc_6162632e78797a_managed_psk"
# alias rsn="connmanctl connect wifi_100ba9094cfc_6e677579656e6e676f63616e68_managed_psk"
alias pmsyu='sudo pacman -Syu'
alias pmsy='sudo pacman -Sy'
alias pms='sudo pacman -S'
alias pmr='sudo pacman -R'
alias i3lock="i3lock -k"
alias d='cd ~/Downloads'
alias D='cd ~/Documents'
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -v'
alias ka='sudo killall'
alias cf='cd ~/.config'
alias aircrack="aircrack-ng -w ~/gits/wordlists/wifi-chua.txt"
alias mpvi="mpv --ytdl-raw-options=write-sub=,write-auto-sub=,sub-lang=vi" 
alias mpvh="mpv --ytdl-format='[height<=?1080]'"
alias mpvm="mpv --ytdl-format='[height<=?720]'"
alias mpvl="mpv --ytdl-format='[height<=?480]'"
alias st_="streamlink -p mpv"

# function field
vman() {
  /usr/bin/man $@ | \
    col -b | \
    vim -R -c 'set ft=man nomod nolist' -
}

ytv()
{
    mpv --ytdl-format='bestvideo[ext=mp4][height<=?360]+bestaudio[ext=m4a]' ytdl://ytsearch:"$*"
}

yta()
{
    mpv --ytdl-format=bestaudio ytdl://ytsearch:"$*"
}

ytal()
{
    mpv --loop=inf --ytdl-format=bestaudio ytdl://ytsearch:"$*"
}

mp3-dl() {
	youtube-dl -i --extract-audio --audio-format mp3 --audio-quality 0 "$*"
}

mp3pl-dl() {
	youtube-dl -ict --yes-playlist --extract-audio --audio-format mp3 --audio-quality 0 "$*"
}
ari() {
    aria2c -c -x3 --seed-time=0 "$*"
}

yayf() { yay -Fy; yay -Slq | fzf --height=100% --multi --preview 'yay -Si {1}' | xargs -ro yay -S --needed ;}
pmf() { sudo pacman -Fy; pacman -Slq | fzf --height=100% --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S --needed ;}

