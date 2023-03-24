#!/bin/bash
# It is assumed that git bash and chocolatey were installed prior to this script.  This script helps to set up a WINDOWS environment.

net session > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
	echo "OK, running as admin"
else 
	echo "Please run this script as administrator"
	exit
fi

if type choco # chocolatey is installed yet?
then
	choco install --yes wget curl ditto freefilesync notepadplusplus
	choco install --yes git gow nvm vim
	choco install --yes openssh
	echo "Now, use freefilesync to pull AppData and other config files out of OneDrive/(employer)"
else
	echo "no chocolatey found"
	exit
fi

echo "Installing sdkman (which helps manage java versions)."

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java    #install latest as default
sdk install tomcat  #install latest as default
sdk install maven   #install latest as default

sdk env install #install java version specified in .sdkmanrc in this project
sdk env #switch to the java version noted in .sdkmanrc

nvm install lts
nvm use lts

# got some of this from stackoverflow, others.
shopt -s nocasematch
if [[ $USERNAME =~ kiroBINS ]]
then
	echo "setting git username and email"
	git config --global user.name "Kimball Robinson"
	git config --global user.email "kimball.robinson@chghealthcare.com"
else
	echo "username not found"
fi

if type curl >/dev/null 2>&1
then 
	echo "Installing oh-my-bash last, since it tends to replace the bashrc"
	echo "installing oh-my-bash"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
else
	echo "curl not installed - aborting"
	exit 0
fi

export MSYS=winsymlinks:nativestrict

echo "Running zscaler setup script" # must come after sdkman
bash setup-scripts/setup-zscaler.bash

choco install --yes powertoys
choco install --yes greenshot # screen capture tool, better than the windows default.
choco install --yes autohotkey # custom hotkeys, keyboard templates, etc
choco install --yes wincompose # a way to compose special characters like the degree symbol, fractions, copyright, and any accented character...
choco install --yes postman powertoys slack 
choco install --yes dbeaver jbs conemu 
#choco install --yes intellijidea-ultimate # perhaps download it manually
#choco install --yes Firefox #probably already installed by now, manually.
# getting to fun/extras...
choco install --yes vlc gimp
#choco install --yes spotify
