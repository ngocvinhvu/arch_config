//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	// {"", "cat /tmp/recordingicon 2>/dev/null",	0,	9},
	{" ",	"ping.sh",	2,	10},
	{" ",	"music",	3,	10},
	{" ",	"iface",	5,	4},
	{" ",	"wifi",	5,	4},
	{" ",	"disk",	5,	10},
	{" ",	"cpu_usage",	2,	10},
	{" ",	"cpu_temp",	2,	10},
	{" ",	"memory",	2,	10},
	{" ",	"weather",	18000,	5},
	{" ",	"battery",	5,	3},
	{" ",	"clock",	60,	1},
	{" ",	"volume",	1,	10},

};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim = '|';

// Have dwmblocks automatically recompile and run when you edit this file in
// vim with the following line in your vimrc/init.vim:

// autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
