#!/usr/bin/env bash

# distro can be one of experimental, unstable, testing or ubuntu.
DISTRO=testing

echo
echo install freemind
echo script by Andreas Krueger 2017, version v01
echo
echo must be run as root:

echo
echo adding repo to /etc/apt/sources.list.d/freemind.list

cat <<EOF >>freemind.list
deb http://eric.lavar.de/comp/linux/debian/ $DISTRO/
deb-src http://eric.lavar.de/comp/linux/debian/ $DISTRO/
EOF

sudo mv freemind.list /etc/apt/sources.list.d/

echo adding PGP key:

wget -O - http://eric.lavar.de/comp/linux/debian/deb_zorglub_s_bawue_de.pubkey | sudo apt-key add -

echo
echo updating:
sudo apt-get update

echo installing:
sudo apt-get install libbatik-java libjcalendar-java freemind
sudo apt-get install freemind-plugins-svg/experimental freemind-plugins-time/experimental freemind-plugins-help/experimental libjgoodies-forms-java/testing

echo
echo done.
# shellcheck disable=SC1010
echo if no error was reported, then freemind got installed. Type \'freemind\' to try. You might want to add a menu entry pointing to this file:
which freemind
echo
