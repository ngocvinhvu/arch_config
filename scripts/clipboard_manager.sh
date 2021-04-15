#!/bin/sh
duy_clipboard_file=$HOME/.duy_clipboard_file
[[ ! -f $duy_clipboard_file ]] && touch $duy_clipboard_file

grab() {
	clip=$(xclip -o)
	echo $clip >> $duy_clipboard_file
}
select2paste() {
	cat $duy_clipboard_file| sort | uniq | dmenu -l 3| xclip -f -sel clip >/dev/null
}
$1
