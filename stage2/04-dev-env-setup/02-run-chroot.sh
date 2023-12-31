
#!/bin/bash -e

if ! [ -d /sloop ]; then
  echo "ERROR: Sloop directory not found"
  exit 1
fi

[ -f /sloop/config ] && source /sloop/config

source /sloop/base.sh
source /sloop/ipad-network.sh
source /sloop/code-server.sh
source /sloop/syncthing.sh
source /sloop/programming-languages.sh

# First, let's run base setup
echo "************* Configuring SSH *************"
configureSsh
echo "************* Finished configuring SSH *************"
echo ""
echo "************* Installing OhMyZsh *************"
installOhMyZsh
echo "************* Finished installing OhMyZsh *************"
echo ""
# Next, let's setup the system for ssh and connection to an iPad
echo "************* Configuring network settings for iPad *************"
updateBootConfig
setupNetwork
echo "************* Completed network configuration for iPad *************"
echo ""

# Next, let's set up code-server
echo "************* Installing NodeJS *************"
nodejs
echo "************* Completed NodeJS installation *************"
echo ""
echo "************* Installing Code Server *************"
installCodeServer
echo "************* Completed Code Server Installation *************"
echo ""
echo "************* Installing Syncthing *************"
installSyncthing
echo "************* Completed Syncthing Installation *************"

# Finally, let's install our remaining programming languages
echo "************* Installing Python *************"
python
echo "************* Completed Python Installation *************"
echo ""
echo "************* Installing Java *************"
java
echo "************* Completed Java Installation *************"
echo ""
echo "************* Installing Golang *************"
golang
echo "************* Completed Golang Installation *************"
echo ""
