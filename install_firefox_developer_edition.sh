#!/bin/bash

file="/tmp/firefox-55.0b14.tar.bz2"
installerFolder="/ExtendInstaller"
sudo mkdir $installerFolder
sudo chown $USER:$USER $installerFolder
# Download Firefox
if [ -f "$file" ]
then
	echo "$file found."
else
	echo "$file not found."
	wget https://download-installer.cdn.mozilla.net/pub/devedition/releases/55.0b14/linux-x86_64/en-US/firefox-55.0b14.tar.bz2 -P /tmp/
fi

# Extract Firefox to ~/.firefox
if [ -d "$installerFolder/firefox" ]
then
	echo "$installerFolder existed"
else
	tar xvjf /tmp/firefox-55.0b14.tar.bz2 -C /tmp && mv /tmp/firefox $installerFolder
fi
cp .materials/Firefox.desktop ~/.local/share/applications
echo "Installed Firefox Developer Edition. Please wait to system update ..."