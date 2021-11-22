#!/bin/bash

# got some of this from stackoverflow, others.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
filesDir="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

destinationDir="$HOME"

echo "Linking from [$filesDir] to [$destinationDir]..."
cd $destinationDir

for f in $filesDir/.[^.]*; do
	basename=`basename $f`
	if [[ ! "$basename" =~ (.gitignore|.git|.swp)$ ]]; then
		targetFile="$destinationDir/$basename"
		fileNote=""
		#echo "$basename";
		if [ -e "$targetFile" ] && [ ! -L "$targetFile" ]; then
			if diff $f $targetFile
			then
				fileNote="(files are the same)"
			else
				cp $targetFile "${targetFile}-old"
				fileNote="(files are different - copy made)"
			fi
		elif [ -L $targetFile ]; then
			fileNote="(file is already a symlink--no action taken)"
		else
			fileNote="(new)" # file does not exist yet.
		fi
		echo "$basename -> $targetFile: $fileNote"
		[[ ! -L $targetFile ]] && ln --symbolic --verbose --interactive $f $destinationDir
	fi
done


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
