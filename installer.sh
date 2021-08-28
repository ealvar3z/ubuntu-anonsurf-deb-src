#!/bin/bash

# Ensure we are being ran as root
if [ $(id -u) -ne 0 ]; then
	echo "This script must be ran as root"
	exit 1
fi

# For upgrades and sanity check, remove any existing i2p.list file
rm -f /etc/apt/sources.list.d/i2p.list

# Compile the i2p ppa
# echo "deb http://deb.i2p2.no/ unstable main" > /etc/apt/sources.list.d/i2p.list # Default config reads repos from sources.list.d
# wget https://geti2p.net/_static/i2p-debian-repo.key.asc -O /tmp/i2p-debian-repo.key.asc # Get the latest i2p repo pubkey
# apt-key add /tmp/i2p-debian-repo.key.asc # Import the key
# rm /tmp/i2p-debian-repo.key.asc # delete the temp key
add-apt-repository ppa:i2p-maintainers/i2p
apt-get update # Update repos

if [[ -n $(cat /etc/os-release |grep ubuntu) ]]
then
	apt-get install libservlet3.1-java
    apt-get install libjetty9-java
	apt-get install libecj-java libgetopt-java glassfish-javaee ttf-dejavu i2p i2p-router libjbigi-jni #installs i2p and other dependencies
	apt-get -f install # resolves anything else in a broken state
fi

apt-get install -y i2p-keyring #this will ensure you get updates to the repository's GPG key
apt-get install -y secure-delete tor i2p # install dependencies, just in case

# Configure and install the .deb
dpkg-deb -b ubuntu-anonsurf-deb-src/ ubuntu-anonsurf.deb # Build the deb package
dpkg -i ubuntu-anonsurf.deb || (apt-get -f install && dpkg -i ubuntu-anonsurf.deb) # this will automatically install the required packages

exit 0
