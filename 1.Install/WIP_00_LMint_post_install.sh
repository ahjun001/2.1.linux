# !/bin/bash -v   # {{{
#
#  Ubuntu post-install script
#
#  Description:
#    A post-installation bash script for Ubuntu (13.10)
#
#  Based on snwh[[0]] and ravishi[[1]] scripts.
#
#  [[0]] - https://github.com/snwh/ubuntu-post-install/
#  [[1]] - https://gist.github.com/ravishi/3706813s
#
#  Usage:
#    $ cd /tmp
#    $ wget http://gist.github.com/raw/8108714/ubuntu-post-install.sh
#    $ chmod +x ubuntu-post-install.sh
#    $ ./ubuntu-post-install.sh
#
#
# set -x
# trap read debug
# trap "set +x; sleep 1; set -x" DEBUG

max_nr_of_batch=28
min=0
max=0
proceed='n'
}}}

batch_1() {
	msg=" 1. Copy one FS into another / review command first" # {{{
	if [[ $min -le 1 ]] && [[ $max -ge 1 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		read -p "Enter n2k k2h h2k or k2n ..." key
		echo "key = " "$key"
		case "$key" in
		n2k)
			orig=/media/perubu/sdb20-Data/
			dest=/media/perubu/CGlide-Data/
			;;
		k2h)
			orig=/media/perubu/CGlide-Data/
			dest=/media/perubu/sda6-Data/
			;;
		h2k)
			orig=/media/perubu/sda6-Data/
			dest=/media/perubu/CGlide-Data/
			;;
		k2n)
			orig=/media/perubu/CGlide-Data/
			dest=/media/perubu/sdb20-Data/
			;;
		*)
			echo -e "First review origin & destination\n"
			exit 1
			orig=/media/
			dest=/media/
			;;
		esac
		echo -e "$ ls orig\n" && ls -d $orig && ls $orig && echo -e "\n\n" && ls -lF $orig/install_pj.sh
		echo -e "Press any key to continue ...\n" && read -n1 -s key
		echo -e "$ ls dest\n" && ls -d $dest && ls $dest && echo -e "\n\n" && ls -lF $dest/install_pj.sh
		echo -e "\nPress any key to copy with rsync..." && read -n1 -s key
		#sudo rsync -axAXS --info=progress2  $orig $dest > ~/rsync.out 2> ~/rsync.err
		sudo rsync -axAXS --info=progress2 $orig $dest
		# -a : all files, with permissions
		## -v : verbose
		# -x : stay on one file system
		## -H : preserve hard links
		# -A : preserve ACLs (Access Control Lists)
		# -X : preserve extended attributes
		# -S : handle sparse files efficiently
		# -- numeric-ids to avoid mapping uid/gid values by user/group name
	fi
} #}}}
batch_2() {
	msg=" 2. Update, Upgrade, Autoremove, & Clean.  FIRST CHECK SOURCES" # {{{
	if [[ $min -le 2 ]] && [[ $max -ge 2 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		echo -e "First change sources to fast ones, then press any key ..." && read -n1 -s key
		sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_3() {
	msg=" 3. Install system utilities" # {{{
	if [[ $min -le 3 ]] && [[ $max -ge 3 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		# cinnamon-core cinnamon-desktop-environment cinnamon-doc
		sudo apt install -y \
			gparted \
			git \
			hardinfo \
			usb-creator-gtk \
			zulumount-gui
		echo -e "$msg" "done.\n"
	fi
} #}}}
batch_4() {
	msg=" 4. Install betterlock" #{{{
	if [[ $min -le 4 ]] && [[ $max -ge 4 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		unzip ./Downloads/betterlock.zip -d ~/.local/share/cinnamon/applets
		/usr/bin/python3 /usr/share/cinnamon/cinnamon-settings/xlet-settings.py applet betterlock 12
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_5() {
	msg=" 5. Install Vim & Neovim" # {{{
	if [[ $min -le 5 ]] && [[ $max -ge 5 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo apt install -y vim
		sudo ln -s /usr/bin/diff /usr/share/vim/vim80/diff
		sudo apt install -y neovim
		sudo ln -s /usr/bin/diff /usr/share/nvim/runtime/diff
		mkdir -vp ~/.local/share/nvim/site/spell/
		mkdir -vp ~/.config/nvim/pack/minpac/opt
		pushd ~/.config/nvim/pack/minpac/opt
		git clone https://github.com/k-takata/minpac
		popd
		cp -rv ./neovim/nvim ~/.config
		cp -v ./neovim/pjp.utf-8.add ~/.local/share/nvim/site/spell/
		mkdir -v ~/.local/share/nvim/swap/
		mkdir -v ~/.local/share/nvim/backup/
		mkdir -v ~/.local/share/nvim/undo/
		sudo ln -s ~/.config/nvim/init.vim /etc/vim/vimrc.local
		echo "Checking for missing packages ..."
		sudo apt install -f
		/usr/bin/vim
		/usr/bin/nvim
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_6() {
	msg=" 6. Install deb packages: Astrill, Grub-customizer" # {{{
	if [[ $min -le 6 ]] && [[ $max -ge 6 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo dpkg -i ./Downloads/astrill-setup-linux64.deb
		sudo dpkg -i ./Downloads/grub-customizer_5.1.0-1_amd64.deb
		sudo apt install -f
		echo -e "$msg" "Done.\n"
	fi

} #}}}
batch_7() {
	msg=" 7. Install Google Chrome" #{{{
	if [[ $min -le 7 ]] && [[ $max -ge 7 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB4C1BFD4F042F6DDDCCEC917721F63BD38B4796 # Google
		# sudo add-apt-repository -y http://dl.google.com/linux/chrome/deb/ stable main /etc/apt/sources.list.d/google-chrome.list
		sudo dpkg -i ./Downloads/google-chrome-stable_current_amd64.deb
		sudo apt install -f
		sudo apt update && sudo apt upgrade -y
		# sudo apt install -y google-chrome-stable --allow-unauthenticated
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_8() {
	msg=" 8. Install sogoupinyin" # {{{
	if [[ $min -le 8 ]] && [[ $max -ge 8 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo apt install \
			libpinyin13 \
			fcitx-config-gtk \
			fcitx \
			fcitx-frontend-gtk2 \
			fcitx-frontend-gtk3 \
			fcitx-frontend-qt4 \
			fcitx-module-x11 \
			libfcitx-qt0 \
			fcitx-module-kimpanel \
			libopencc2 \
			fcitx-libs \
			libqt4-dbus \
			libqt4-declarative \
			libqt4-network \
			libqtcore4 \
			libqtgui4 \
			libqtwebkit4 \
			-y
		sudo dpkg -i ./Downloads/sogoupinyin_2.2.0.0108_pjp.deb
		echo "Updating, upgrading, autoremoving, & cleaning ..."
		sudo apt update && sudo apt upgrade -y && sudo apt autoremove && sudo apt clean
		echo "\n\n"
		/usr/bin/fcitx
		/usr/bin/fcitx-configtool
		echo "if doesn't work, install fcitx-rime, install sogou-pinyin, then remove fcitx-rime"
	fi
} #}}}
batch_9() {
	msg=" 9. Install Python & developer packages" # {{{
	if [[ $min -le 9 ]] && [[ $max -ge 9 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo apt install -y \
			xsel \
			python-pip python3-pip \
			python-neovim python3-neovim
		sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1
		sudo apt install python3-setuptools python3-wheel
		#pip3 install setuptools
		pip install pynvim
		pip3 install pynvim
		echo "\nTest nvim:checkhealth, press any key to continue ..." && read -n1 -s key
		nvim
		sudo apt install python3-venv python3-virtualenv python3-pytest pytest \
			python-dev python3-dev
		pip install virtualenvwrapper cookiecutter
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_10() {
	msg="10. Install & test VirtualEnvWrapper: append 4 lines to ~/.bashrc" # {{{
	if [[ $min -le 10 ]] && [[ $max -ge 10 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		wh_dir=$HOME/.virtualenvs
		ph_dir=$HOME/Devel
		echo "=> Modify .bashrc" &&
			echo " " >>~/.bashrc &&
			echo "# Setting virtualenvwrapper.sh" >>~/.bashrc &&
			echo "export WORKON_HOME=$HOME/.virtualenvs" >>~/.bashrc &&
			echo "export PROJECT_HOME=$HOME/Devel" >>~/.bashrc &&
			echo "source /home/perubu/.local/bin/virtualenvwrapper.sh" >>~/.bashrc
		#&& echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> ~/.bashrc
		echo "=> .bashrc modified"
		tail ~/.bashrc
		mkdir -vp "$wh_dir" && echo "mkdir -vp $wh_dir done.\n"
		mkdir -vp "$ph_dir" && echo "mkdir -vp $ph_dir done.\n"

		echo -e "\nDoes not run from script: run from bash \nsource ~/.bashrc \nmkvirtualenv env1 \nworkon \nlssitepackages \ndeactivate \nrmvirtualenv env1"
		# rm -rv ~/.virtualenvs
		# rm -rv ~/Devel
		echo -e "\n$msg" "Done.\n"
	fi
} #}}}
batch_11() {
	msg="11. Install VMWare player" #{{{
	if [[ $min -le 11 ]] && [[ $max -ge 11 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		chmod +x ./Downloads/VMware-Player-15.*.x86_64.bundle
		sudo ./Downloads/VMware-Player-15.*.x86_64.bundle

		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_12() {
	msg="12. Install boot-repair" #{{{
	if [[ $min -le 12 ]] && [[ $max -ge 12 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt update
		sudo apt install -yy boot-repair && boot-repair
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_13() {
	msg="13. Install unetbootin" #{{{
	if [[ $min -le 13 ]] && [[ $max -ge 13 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo apt install extlinux # required for unetbootin
		sudo add-apt-repository ppa:gezakovacs/ppa
		sudo apt update
		sudo apt install unetbootin
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_14() {
	msg="14. Install ubuntu-kylin-software-center" # {{{
	if [[ $min -le 14 ]] && [[ $max -ge 14 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		# sudo add-apt-repository -y http://archive.ubuntukylin.com:10006/ubuntukylin bionic main /etc/apt/sources.list.d/sources.list
		sudo apt install ubuntu-kylin-software-center
		echo "Updating, upgrading, autoremoving, & cleaning ..."
		sudo apt update && sudo apt upgrade -y && sudo apt autoremove && sudo apt clean
		echo "\n\n"
		usr/bin/ubuntu-kylin-software-center
	fi
} #}}}
batch_15() {
	msg="16. Install PostgreSQL" #{{{
	if [[ $min -le 15 ]] && [[ $max -ge 15 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
		wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
		sudo apt update
		sudo apt install postgresql-11 postgresql-contrib
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_16() {
	msg="16. Install pgAdmin4 libs for Python" #{{{
	if [[ $min -le 16 ]] && [[ $max -ge 16 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		# sudo apt install libpq-dev libpq5:amd64
		# wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v2.0/pip/pgadmin4-2.0-py2.py3-none-any.whl
		# echo "$ mkvirtualenv py3-venv-pgadmin"
		# echo "$ pip3 install pgadmin4-2.0-py2.py3-none-any.whl"
		# cd ~/Devel/py3-venv-pgadmin/lib/python3.6/site-packages/pgadmin4
		# sudo apt install pgadmin4 pgadmin4-apache2
		google-chrome --disable-gpu --disable-software-rasterizer http://127.0.0.1:5050/pgAdmin4

		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_17() {
	msg="17. Install Etherape" #{{{
	if [[ $min -le 17 ]] && [[ $max -ge 17 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo apt install libgnomeui-0 etherape
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_18() {
	msg="18. Install Cinnamon desktop environment" #{{{
	if [[ $min -le 18 ]] && [[ $max -ge 18 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo add-apt-repository universe
		sudo apt install cinnamon-desktop-environment lightdm
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_19() {
	msg="19. Install file sharing via Samba" #{{{
	if [[ $min -le 19 ]] && [[ $max -ge 19 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo apt install samba
		sudo apt install cifs-utils
		sudo apt install smbclient
		sudo apt install system-config-samba
		sudo smbpasswd -a perubu
		id -Gn
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_20() {
	msg="20. Install wkhtmltopdf" #{{{
	if [[ $min -le 20 ]] && [[ $max -ge 20 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo wget https://builds.wkhtmltopdf.org/0.12.1.3/wkhtmltox_0.12.1.3-1~bionic_amd64.deb
		sudo dpkg -i wkhtmltox_0.12.1.3-1~bionic_amd64.deb
		sudo apt-get install -f
		sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
		sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin
	fi
} #}}}
batch_21() {
	msg="21. Compile & install pgModeler" #{{{
	if [[ $min -le 21 ]] && [[ $max -ge 21 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		export PG_FILE=pgmodeler-0.9.2-beta      # version to be compiled, pjp
		export QT_ROOT=/opt/Qt/5.9.8/gcc_64      # full path to Qt installation
		export INSTALLATION_ROOT=/opt/pgmodeler  # where the pgModeler should be installed after building
		export PGSQL_ROOT=/usr/lib/postgresql/11 # full path to postgreSQL install
		export PGMODELER_SOURCE=/tmp/$PG_FILE    # pgModeler's source code directory

		tar -xf ~/Downloads/"$PG_FILE.tar.gz" -C /tmp

		cd $PGMODELER_SOURCE

		qmake -version
		echo
		echo QMake version 3.1
		echo Using Qt version 5.12.0 in /usr/lib64
		read -p "Press Enter to continue"
		pkg-config libxml-2.0 --cflags --libs
		echo
		echo -I/usr/include/libxml2 -lxml2
		read -p "Press Enter to continue"

		if [ -d "$INSTALLATION_ROOT" ]; then -Rf $INSTALLATION_ROOT; fi

		sudo $QT_ROOT/bin/qmake -r CONFIG+=release PREFIX=$INSTALLATION_ROOT BINDIR=$INSTALLATION_ROOT \
			PRIVATEBINDIR=$INSTALLATION_ROOT PRIVATELIBDIR=$INSTALLATION_ROOT/lib pgmodeler.pro
		sudo make
		sudo make install

		cd $QT_ROOT/lib
		sudo cp -v libQt5DBus.so.5 libQt5PrintSupport.so.5 libQt5Widgets.so.5 libQt5Network.so.5 libQt5Gui.so.5 \
			libQt5Core.so.5 libQt5XcbQpa.so.5 libQt5Svg.so.5 libicui18n.so.* libicuuc.so.* libicudata.so.* $INSTALLATION_ROOT/lib
		cd $QT_ROOT/plugins
		sudo mkdir $INSTALLATION_ROOT/lib/qtplugins
		sudo mkdir $INSTALLATION_ROOT/lib/qtplugins/imageformats
		sudo mkdir $INSTALLATION_ROOT/lib/qtplugins/printsupport
		sudo mkdir $INSTALLATION_ROOT/lib/qtplugins/platforms
		sudo cp -v -r imageformats/libqgif.so imageformats/libqico.so imageformats/libqjpeg.so imageformats/libqsvg.so \
			imageformats/libqtga.so imageformats/libqtiff.so imageformats/libqwbmp.so $INSTALLATION_ROOT/lib/qtplugins/imageformats
		sudo cp -v -r printsupport/libcupsprintersupport.so $INSTALLATION_ROOT/lib/qtplugins/printsupport
		sudo cp -v -r platforms/libqxcb.so $INSTALLATION_ROOT/lib/qtplugins/platforms
		sudo echo -e "[Paths]\nPrefix=.\nPlugins=lib/qtplugins\nLibraries=lib" >$INSTALLATION_ROOT/qt.conf
		sudo cp -v $PGMODELER_SOURCE/start-pgmodeler.sh $PGMODELER_SOURCE/pgmodeler.vars $INSTALLATION_ROOT
		chmod +x $INSTALLATION_ROOT/start-pgmodeler.sh

		cd $INSTALLATION_ROOT
		./start-pgmodeler.sh
	fi
} #}}}
batch_22() {
	msg="22. List recently installed packaged names" #{{{
	if [[ $min -le 22 ]] && [[ $max -ge 22 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		grep ' install ' /var/log/apt/history.log
		echo -e "$msg" "Done.\n"
	fi
} #}}}
batch_23() {
	msg="23. vide pour l'instant " #{{{
	if [[ $min -le 23 ]] && [[ $max -ge 23 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		echo "rien pour l'instant"
	fi
} #}}}
batch_24() {
	msg="24. Install meld, visual diff for dir & files" #{{{
	if [[ $min -le 24 ]] && [[ $max -ge 24 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		sudo apt install meld
		sudo apt install intltool itstool gir1.2-gtksource-3.0 libxml2-utils pygobject==3.30.0
		cd /opt
		sudo git clone https://git.gnome.org/browse/meld
		cd meld
		sudo python3 setup.py install
	fi
} #}}}
batch_25() {
	msg="25. Install pavucontrol" #{{{
	if [[ $min -le 25 ]] && [[ $max -ge 25 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		# run pavucontrol, output Devices, click off cadenas & check
		echo -n "run pavucontrol, output Devices, click off cadenas & check"
	fi
} #}}}
batch_26() {
	msg="26. Install webmin" #{{{
	if [[ $min -le 26 ]] && [[ $max -ge 26 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		echo "deb http://download.webmin.com/download/repository sarge contrib" | sudo tee /etc/apt/sources.list.d/webmin.list
		wget http://www.webmin.com/jcameron-key.asc -O - | sudo apt-key add -
		sudo apt update
		sudo apt install -y webmin
		sudo sed -e 's/^port=.*/port=10002/g' -e 's/^listen=.*/listen=10002/g' -i /etc/webmin/miniserv.conf
		sudo systemctl restart webmin
		# google-chrome https://127.0.0.1:10002, login with linux user and password
	fi
} #}}}
batch_27() {
	msg="27. Install Wine" #{{{
	if [[ $min -le 27 ]] && [[ $max -ge 27 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		# install wine from https://www.tecmint.com/install-wine-on-ubuntu-and-linux-mint/
		# check wiki.winehq.org/Ubuntu for info
		sudo dpkg --add-architecture i386
		wget -nc https://dl.winehq.org/wine-builds/winehq.key
		sudo apt-key add winehq.key
		sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' [Ubuntu 18.04 &
		Linux Mint 19.x]
		sudo apt-get update
		sudo apt-get install --install-recommends winehq-stable
	fi
} #}}}
batch_28() {
	msg="28. Install fonts for wine in Chinese" #{{{
	if [[ $min -le 28 ]] && [[ $max -ge 28 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		export WINEARCH=win32
		export WINEPREFIX=~/.wine32
		winecfg
		cd ~/Downloads
		wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
		cp winetricks /tmp
		cd /tmp
		chmod +x winetricks
		sudo apt install cabextract
		./winetricks corefonts gdiplus riched20 riched30 wenquanyi
		./winetricks regedit
		# In the Menu bar, click Registry and select Import Registry File…
		# When the browser shows up, select the .reg file you have just downloaded -- ch_font.reg
	fi
} #}}}

# Selecting {{{
while :; do
	clear
	for i in $(seq 1 $max_nr_of_batch); do
		eval batch_$i
	done

	echo -e "\n"
	read -p "Enter 'y'to process '' to change selection: [] " proceed
	if [[ "$proceed" = "y" ]]; then
		break
	fi

	if [[ ! "$proceed" = 'y' ]]; then
		while :; do
			read -p "Enter nr of 1rst batch to process: " min
			if [[ "$min" -le "$max_nr_of_batch" ]]; then
				break
			fi
		done

		while :; do
			read -p "Enter nr of last batch to process: " max
			if [[ "$min" -le "$max" ]]; then
				break
			fi
		done
	fi
done
# Running
for i in $(seq $min $max); do
	eval batch_$i
done
# }}}

batch_4() {
	msg="4. Old sogoupinyin" # {{{
	if [[ $min -le 4 ]] && [[ $max -ge 4 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		echo "------------------------------------------------------------------------"
		echo "=> Check: Menu / Languages / (upgrade) / English system wide   also check language support / Reboot"
		echo "------------------------------------------------------------------------"
		sudo add-apt-repository -y http://archive.ubuntukylin.com:10006/ubuntukylin bionic main /etc/apt/sources.list.d/sources.list
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D259B7555E1D3C58
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4CCA1EAF950CEE4AB83976DCAD40830F7FAC5991
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F2EDC64DC5AEE1F6B9C62AF0C8CAB6595FDFF622
		sudo dpkg -i ./Downloads/sogoupinyin_2.2.0.0108_amd64.deb
		sudo apt install -f
		sudo apt update
		/usr/bin/fcitx
		/usr/bin/fcitx-configtool
		echo -e "$msg" "Done.\n"
		# fcitx-config-gtk \
		# sudo add-apt-repository -y http://archive.ubuntukylin.com:10006/ubuntukylin bionic main /etc/apt/sources.list.d/sogoupinyin.list
		# sudo set -i '$a\deb http://archive.ubuntukylin.com:10006/ubuntukylin bionic main' /etc/apt/sources.list
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4CCA1EAF950CEE4AB83976DCAD40830F7FAC5991
		# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F2EDC64DC5AEE1F6B9C62AF0C8CAB6595FDFF622
	fi
} #}}}
batch_9() {
	msg="9. old kylin-software-center" # {{{
	if [[ $min -le 9 ]] && [[ $max -ge 9 ]]; then
		echo -n "v "
	else
		echo -n "  "
	fi
	echo "$msg"
	if [[ "$proceed" = "y" ]]; then
		# sudo add-apt-repository -y http://archive.ubuntukylin.com:10006/ubuntukylin bionic main /etc/apt/sources.list.d/sources.list
		sudo apt install ubuntu-kylin-software-center
		usr/bin/ubuntu-kylin-software-center
		# echo -e "Reviewing sources, press :n / :p for next / previous file\n"
		# less /etc/apt/sources.list.d/*
		# echo -e "\n\n"
		# sudo apt install \
		libpinyin-data \
			libpinyin \
			fcitx-config-gtk
		# sudo apt install \
		adobe-flash-properties-gtk \
			adobe-flash-properties-kde \
			adobe-flashplugin \
			google-cloud-sdk \
			ibm-java80-jdk \
			ibm-java80-jre \
			ibm-java80-plugin
		echo "Checking for missing packages ..."
		sudo apt install -f
		echo "Updating, upgrading, autoremoving, & cleaning ..."
		sudo apt update && sudo apt upgrade -y && sudo apt autoremove && sudo apt clean
		echo "\n\n"
		# /usr/bin/fcitx
		# /usr/bin/fcitx-configtool
	fi
} #}}}

# vim:ft=sh:fdm=marker:
