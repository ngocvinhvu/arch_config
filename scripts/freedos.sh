#!/usr/bin/bash
# qemu-system-i386 -m 16 -k en-us -rtc base=localtime -soundhw sb16,adlib -device cirrus-vga -display gtk -hda /mnt/sdb3/os/dos.img -drive file=fat:rw:/mnt/sdb3/os/dosfiles/
qemu-system-i386 -m 16 -k en-us -rtc base=localtime -soundhw all -device cirrus-vga -display gtk -hda /mnt/sdb3/os/dos.img -drive file=fat:rw:/mnt/sdb3/os/dosfiles/
