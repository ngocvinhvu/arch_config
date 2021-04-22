#! /bin/bash
# dclip-1.0 || Delta 30dic08
file=$HOME/.dclip_cache
size=10
if [ "$1" == "copy" ]; then
    sel_clip=$(xsel -o)
    sel_file=$(echo -n "$sel_clip"|tr '\n' '\034')
	sed "/^$sel_file$/d" -i $file
	cut=$(head -n $(($size-1)) $file)
	echo "$sel_file" > $file
	echo -n "$cut" >> $file
fi
# touch $file
if [ "$1" == "paste" ]; then
    shift
    sel_file=$(awk '!x[$0]++' $file | uniq | dmenu -l 10 ${1+"$@"}) 
	echo $sel_file | xclip -f -sel clip > /dev/null
fi
if [ "$1" == "clear" ]; then
	echo -n > $file
fi
[ "$sel_clip" == "" ] && exit 1
