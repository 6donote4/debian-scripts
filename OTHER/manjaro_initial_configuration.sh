 #/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
 #========================================
 # Distribution: Manjaro
 # Description: Configure Manjaro distribution environment
 # Author: 6donoto4 <mailto:donote@hotmail.com>
 # Blog: https://www.donote.tk https://6donote4.github.io
 #========================================
 sudo yes|pacman -Syuu
 sudo pacman -S nginx proxychains \
     tsocks yaourt yaourt-gui aria2 \
     filezilla chromium kodi qmmp vim \
     emacs telegram tightvnc nmap fcitx \
     qbittorent riot utox syncthing \
     geany stardict
 sudo yaourt -S woeusb cydia-impactor
 sudo systemctl enable vncserver@3
 exit 0

