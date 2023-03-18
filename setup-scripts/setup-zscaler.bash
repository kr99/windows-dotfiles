# check that we're running as admin by trying to run a useless admin command
net session > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
	echo "OK, running as admin"
else 
	echo "Please run this script as administrator"
	exit
fi

# check for GOW setup and commands
keytool > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
	echo "OK: keytool found"
else 
	echo "keytool is not found.  This is a gnu util you can get by installing Git On Windows (GOW)"
	echo "exiting"
	exit
fi


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