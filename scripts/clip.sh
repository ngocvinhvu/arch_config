#! /bin/bash

file=$HOME/.dclip_cache
size=10

if [ "$1" == "copy" ]; then
    sel_clip=$(xsel -o)
    sel_file=$(echo -n "$sel_clip"|tr '\n' '\034')
fi
touch $file
if [ "$1" == "paste" ]; then
    shift
    sel_file=$(awk '!x[$0]++' $file | dmenu -l 3 ${1+"$@"})
    sel_clip=$(echo -n "$sel_file"|tr '\034' '\n')
fi

if [ "$1" == "clear" ]; then
	echo -n > $file
fi

[ "$sel_clip" == "" ] && exit 1

sed "/^$sel_file$/d" -i $file
cut=$(head -n $(($size-1)) $file)
echo "$sel_file" > $file
echo -n "$cut" >> $file

echo -n "$sel_clip" | xsel -p -i
echo -n "$sel_clip" | xsel -b -i

exit 0 
