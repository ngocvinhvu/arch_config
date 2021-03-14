#!/bin/bash

url=$({
    cat ~/.config/qutebrowser/bookmarks/urls
    awk '{ tmp = $1; $1 = $2; $2 = tmp; print $0 }' ~/.config/qutebrowser/quickmarks
    sqlite3 -separator ' ' ~/.local/share/qutebrowser/history.sqlite 'SELECT url, title FROM CompletionHistory'
} | sort | uniq | dmenu -l 10 -p "qute history search $* " | cut -d ' ' -f 1)

[[ -n $url ]] && $BROWSER $url || exit 0
