[abc.xyz](#q1)
## Setup USB boot:
#dd if=/ARCHLINUX.iso  of=/dev/sdb status="progress" bs=4M
#
## Format and partition:
#mkfs.ext4 /dev/sdaX    - Arch linux partition

#mkswap /dev/sdaY       - Swap partition

#swapon  /dev/sdaY
#
## Connect to internet:
#wifi-menu         # if use wifi

#dhcpdp eth0      # if use ethenet

#ping 1.1.1.1 -c 2  # test network
#
## Mount to installing partition
#mount /dev/sdaX /mnt
#
## Choose mirror repository you like in:
#/etc/pacman.d/mirrorlist
#
## Install base linux linux-firmware 
#pacstrap /mnt base linux linux-firmware 
#
## Create fstab partition:
#genfstab -U /mnt >> /mnt/etc/fstab
#
## Chroot to new system:
#arch-chroot /mnt
## Install some basic package

#pacman -S dialog wpa_supplicant ppp dhcpcd
#
#vi /etc/hostname  #set name

#ln -sf /usr/share//zoneinfo/Asia/Ho_Chi_Minh /etc/localtime  #config timezone

#echo LANG=en_US.UTF-8 > /etc/locale.conf

#uncomment en_US.* in /etc/locale.gen

#locale-gen

#mkinitcpio -P

#pacman -S grub

#grub-install --target=i386-pc /dev/sdX

#grub-mkconfig -o /boot/grub/grub.cfg
#
#exit

#umount -R /mnt

#reboot
#
#
## Install graphical enviroment:

#pacman -Syu

#pacman -S xorg-server xorg-apps xorg-xinit i3 numlockx

#pacman -S lightdm lightdm-gtk-greeter

#pacman -S noto-fonts noto-fonts-emoji ttf-ubuntu-font-family ttf-dejavu ttf-freefont ttf-liberation ttf-droid ttf-inconsolata ttf-roboto terminus-font ttf-font-awesome

#pacman -S alsa-utils alsa-plugins alsa-lib pavucontrol

#pacman -S rxvt-unicode ranger rofi conky dmenu urxvt-perls perl-anyevent-i3 perl-json-xs

#pacman -S atool highlight mediainfo w3m ffmpegthumbnailer zathura 

#pacman -S firefox mpv mplayer feh sxiv scrot mtpfs gvfs-mtp pulseaudio git ibus-unikey ncmpcpp mpd mpc python-pip

#pip install --user python-mpd2 
#
## config audio

#vim /etc/modprobe.d/alsa-base.conf

#options snd_mia index=0

#options snd_hda_intel index=1
#
#systemctl enable lightdm

#systemctl start lightdm
#
## create user:

#useradd -m -g wheel duy
#
## install yay:

#git clone https://aur.archlinux.org/yay.git

#cd yay

#makepkg -si

#yay -Syyuu

#yay -S urxvt-font-size-git python-pdftotext scrcpy
#
## Config files:
#
#git clone https://github.com/laduygaga/arch_config
#
## Connect to android device and iphone

#pacman -S mtpfs ifuse android-file-transfer

#yay -S jmtpfs
#
## vimvuldle

#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#
## docker-ce

#pacman -S docker

### abc.xyz
    fdsfdsdf
    sdfs
    dfdsfdsfs

