#!/bin/sh

# Setup Desktop links
# ARM Images links
ln -s "/mnt/cdrom/ARM" "/etc/skel/Desktop/ARM_Images"

# Tigal Desktop link
echo "[Desktop Entry]
Encoding=UTF-8
Icon=/usr/share/pixmaps/sabayon-weblink.png
Type=Link
URL=http://www.tigal.com
Name=Sponsored by Tigal" > /etc/skel/Desktop/tigal.desktop

exit 0
