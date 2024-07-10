# check that we're running as admin by trying to run a useless admin command
net session > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
	echo "OK, running as admin"
else 
	echo "Please run this script as administrator"
	exit
fi

check_keytool() {
    if command -v keytool >/dev/null 2>&1; then
        echo "OK: keytool found"
        return 0
    else
        return 1
    fi
}
show_error() {
    echo -e "\e[31mERROR: $1\e[0m"
}

# Function to set up SDKMAN and Java
setup_sdkman_and_java() {
    # Check if SDKMAN is installed
    if [[ ! -d "$HOME/.sdkman" ]]; then
        echo "SDKMAN not found. Please install SDKMAN first."
        echo "Visit https://sdkman.io/install for installation instructions."
        return 1
    fi

    # Load SDKMAN
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    # Check for installed Java versions
    local installed_java=$(sdk list java | grep installed | awk '{print $NF}' | sort -V | tail -n1)

    if [[ -z "$installed_java" ]]; then
        echo "No Java version found. Installing latest LTS version..."
        sdk install java
    else
        echo "Using latest installed Java version: $installed_java"
        sdk use java $installed_java
    fi

    # Update JAVA_HOME
    export JAVA_HOME=$(sdk home java current)
    export PATH=$JAVA_HOME/bin:$PATH
}


# Function to ensure keytool is available
ensure_keytool() {
    if ! check_keytool; then
        show_error "keytool not found. Attempting to set up Java using SDKMAN..."
        if setup_sdkman_and_java; then
            if check_keytool; then
                echo "keytool is now available."
            else
                show_error "Failed to find keytool even after setting up Java. Please check your Java installation."
                return 1
            fi
        else
            show_error "Failed to set up Java. Please install Java manually and ensure JAVA_HOME is set."
            return 1
        fi
    fi
    return 0
}

if ! ensure_keytool; then
    exit 1
fi

## check for keytool
#if ! check_keytool; then
#    echo "keytool not found. Attempting to set up Java using SDKMAN..."
#    if setup_sdkman_and_java; then
#        if check_keytool; then
#            echo "keytool is now available."
#        else
#            echo "Failed to find keytool even after setting up Java. Please check your Java installation."
#            exit 1
#        fi
#    else
#        echo "Failed to set up Java. Please install Java manually and ensure JAVA_HOME is set."
#        exit 1
#    fi
#fi


# Check for certs file and set up variables
cd ~
expectedFile=$HOME/Downloads/ZscalerRootCerts.zip 
if [[ -f $expectedFile ]]; then
	echo "OK: found certs file in download folder"
else
	echo "You must download certs file first: expected $expectedFile." 
	exit
fi 

ls -l $expectedFile
echo ok
unzip -o $expectedFile
expectedCrtFile=ZscalerRootCerts/ZscalerRootCertificate-2048-SHA256.crt
ls -l $expectedCrtFile

if [[ -e $JAVA_HOME ]]; then
	outputFile=$JAVA_HOME/bin/ZscalerRootCertificate.der 
	openssl x509 -in $expectedCrtFile -inform pem -out $outputFile -outform der
	ls -l $outputFile
	echo
	echo "adding cert to current java instance inside JAVA_HOME at $JAVA_HOME"
	set -x
	# changeit is the default password for java installs; unless you've changed it, this should just work.
	keytool  -import  -trustcacerts -alias zscalerrootcaChg -file $outputFile -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit
	set +x
else
  echo "JAVA_HOME not defined.  Skipping java cert setup"
  sleep 3
fi




echo
echo
echo
echo
echo "setting git.exe to use local windows CA store"
#set -x
git config --global http.sslBackend schannel
set +x
