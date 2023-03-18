#!/bin/bash

# got some of this from stackoverflow, others.


export MSYS=winsymlinks:nativestrict


echo "Installing sdkman (which helps manage java versions)."

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java    #install latest as default
sdk install tomcat  #install latest as default
sdk install maven   #install latest as default

sdk env install #install java version specified in .sdkmanrc in this project
sdk env #switch to the java version noted in .sdkmanrc



echo "Installing oh-my-bash last, as it takes over"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
