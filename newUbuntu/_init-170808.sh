#!/bin/bash

# Pre functions

RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

printfn(){
	printf "${1} \n"
}

install_each_package(){
	for package in "$@"
	do
			printfn "${RED}Installing $package ..."
	    sudo apt-fast install $package -y
	done
}

install_package(){
	printfn "${RED}Installing $@ ..."
	sudo apt-fast install $@ -y
}

upgrade_package(){
	printfn "${RED}Upgrade package..."
	sudo apt-fast upgrade -y && sudo apt-fast -y dist-upgrade
}

check_and_add_ppa(){
	ppa=$1
	if ! grep -q "^deb .*$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    printfn "${RED}Adding $ppa ppa"
		sudo add-apt-repository ppa:$ppa -y
	else
		printfn "$ppa ${RED}existed"
	fi
}


# Install `apt-fast`
function install_aptFast (){
	aptFast_ppa="saiarcot895/myppa"
	printfn "${RED}The first, install apt-fast!"
	if ! grep -q "^deb .*$aptFast_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    printfn "${RED}Adding apt-fast ppa"
		sudo add-apt-repository ppa:saiarcot895/myppa -y &
		sudo apt-get update &
		sudo apt-get -y install apt-fast
	else
		printfn "${RED}apt-fast ppa existed"
	fi

}

# install_aptFast


sublime_text(){
	check_and_add_ppa "webupd8team/sublime-text-3" &
	sudo apt-fast update &
	sudo apt-fast install sublime-text-installer -y
}

typora(){
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
	sudo add-apt-repository 'deb https://typora.io ./linux/'
	sudo apt-get update
	sudo apt-fast install typora -y

}
typora

mount_some_partions(){
  fsTab='/etc/fstab'
  if grep "/media/" $fsTab; then
  	printfn "Mounted some partions"
  else
  	printfn "Mounting..."
  	echo "/dev/sda5                /media/EXT       ext4    defaults        0 0" >> $fsTab
  	echo "/dev/sda6                /media/DATA       ntfs    defaults        0 0" >> $fsTab
  	printfn "Has mounted"
  fi
}
mount_some_partions

# Install Packages
basic_package="ubuntu-restricted-extras vlc goldendict flashplugin-installer ibus-unikey"
advance_package="audacious shutter glipper gimp "
indicator_package="indicator-cpufreq indicator-multiload caffeine"
developer_package="zsh git vim tmux"
systems_package="dconf-tools gnome-tweak-tool unity-tweak-tool synaptic gdebi font-manager"
chromium_package="chromium-browser"

all_packages="$basic_package $advance_package $indicator_package $developer_package $systems_package $chromium_package"
install_package $all_packages
upgrade_package

list_ppa="webupd8team/java"


# Install ruby

install_ruby_for_ubuntu(){
	install_package curl &
	bash < <(curl -sL  https://raw.github.com/railsgirls/installation-scripts/master/rails-install-ubuntu.sh) &
	echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
}

# install_ruby_for_ubuntu


# Setting

# Install yard zsh
install_yard_zsh(){
	sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`" -s ask
}

install_source_code_pro_fonts(){
	printfn "${RED}Clone and Install Source Code Pro font"
	git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git ~/.fonts/adobe-fonts/source-code-pro
	fc-cache -f -v ~/.fonts/adobe-fonts/source-code-pro
}

install_source_code_pro_fonts

link_personal_setting(){
	cd ~/
	printfn "${RED}Clear all symbolic links"
	rm -rf .zsh.after .zsh.before .tmux.conf.user .vimrc.before .vimrc.after .gitconfig.user .gitignore.user .fasd .ssh
	printfn "${RED}Link Exist Personal Setting ..."
	ln -s /media/EXT/Linux/data/setting/.tmux.conf.user
	ln -s /media/EXT/Linux/data/setting/.zsh.after
	ln -s /media/EXT/Linux/data/setting/.zsh.before

	ln -s /media/EXT/Linux/data/setting/.vimrc.before
	ln -s /media/EXT/Linux/data/setting/.vimrc.after
	ln -s /media/EXT/Linux/data/setting/.gitconfig.user
	ln -s /media/EXT/Linux/data/setting/.gitignore.user
	ln -s /media/EXT/Linux/data/setting/.fasd
	ln -s /media/EXT/Linux/data/setting/.ssh
	printfn "${BLUE}Done"
}


install_yard_zsh
link_personal_setting

set_default_shell_is_zsh(){
	sudo chsh -s $(which zsh)
}
set_default_shell_is_zsh


use_base16_theme_for_gnome_terminal(){
	if [ ! -d ~/.config/base16-gnome-terminal ]; then
		git clone https://github.com/aaron-williamson/base16-gnome-terminal.git ~/.config/base16-gnome-terminal
		.config/base16-gnome-terminal/color-scripts/base16-default-dark.sh
		printfn "Using Base16 theme"
	else
		printfn "Used Base16 theme"
	fi
}

use_base16_theme_for_gnome_terminal


clear_and_link_symlink_pc_home(){
	cd ~/
	rm -rf ~/Desktop ~/Documents ~/Music ~/Pictures ~/Videos ~/Downloads

	ln -s /media/EXT/Dropbox/Desktop
	ln -s /media/DATA/MyPCHome/Documents
	ln -s /media/DATA/MyPCHome/Music
	ln -s /media/DATA/MyPCHome/Pictures
	ln -s /media/DATA/MyPCHome/Videos
	ln -s /media/DATA/MyPCHome/Downloads
	printfn "${BLUE}Linked PC Home Dicrectory"
}

clear_and_link_symlink_pc_home

clear_and_link_software_settings(){
	cd ~/
	rm -rf .goldendict
	ln -s /media/EXT/Linux/data/setting/.goldendict
	printfn "${BLUE}Linked Software settings"
}

clear_and_link_software_settings

install_theme(){
	printfn "${BLUE} Install themes"
}

install_theme

install_ranger(){
	cd /tmp
	wget https://github.com/ranger/ranger/archive/master.zip -O ranger-master.zip
	rm -rf ranger-master
	unzip ranger-master.zip
	cd ranger-master
	sudo make install
	printfn "Installed ${BLUE}`ranger --version | sed -n 1p` \n"

	install_ranger_plugin(){
		cd /tmp
		wget https://github.com/alexanderjeurissen/ranger_devicons/archive/master.zip -O ranger_devicons-master.zip
		rm -rf ranger_devicons-master
		unzip ranger_devicons-master.zip && cd ranger_devicons-master
		make install
		# make uninstall
	}
	install_font_support_ranger(){
		cd ~/.fonts
		wget https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
		fc-cache -f -v ~/.fonts
	}
	install_ranger_plugin
	install_font_support_ranger
}

install_ranger