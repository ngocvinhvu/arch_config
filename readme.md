# rc.conf
    set ranger_load_default_rc false # add to rc.conf

# mpv as default app for gif files
    mime ^image/gif, has mpv,     X, flag f = mpv --loop=0 -- "$@" # add to rifle.conf

# open gif in shell just: file.gif :easy:
alias -s gif='mpv --loop=0'   # add to .zshrc
alias -s webm='mpv --loop=0'  #
