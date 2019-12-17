​
#Configure desktop environment , VNC server and Chromium web browser on Debian server.
#Debian服務器桌面環境、VNC及谷歌瀏覽器配置腳本
#!/bin/bash
yes | apt-get install lxde lxlauncher lxtask tightvncserver xfonts-base chromium xfce4-power-manager update-notifier usermode ttf-wqy-microhei matchbox-keyboard vim gadmin-samba nodejs 

dpkg-reconfigure locales
