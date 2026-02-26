#!/bin/bash

# Function to display error messages in red
show_error() {
    echo -e "\e[31mERROR: $1\e[0m"
}

# Function to check if running as admin
check_admin() {
    net session > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "OK, running as admin"
        return 0
    else 
        show_error "Please run this script as administrator"
        return 1
    fi
}

# Function to check if keytool is available
check_keytool() {
    if command -v keytool >/dev/null 2>&1; then
        echo "OK: keytool found"
        return 0
    else
        return 1
    fi
}

# Function to set up SDKMAN and Java
setup_sdkman_and_java() {
    if [[ ! -d "$HOME/.sdkman" ]]; then
        show_error "SDKMAN not found. Please install SDKMAN first."
        echo "Visit https://sdkman.io/install for installation instructions."
        return 1
    fi

    source "$HOME/.sdkman/bin/sdkman-init.sh"

    local installed_java=$(sdk list java | grep installed | awk '{print $NF}' | sort -V | tail -n1)

    if [[ -z "$installed_java" ]]; then
        echo "No Java version found. Installing latest LTS version..."
        sdk install java
    else
        echo "Using latest installed Java version: $installed_java"
        sdk use java $installed_java
    fi

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

# Function to verify Java and keytool accessibility
verify_java_keytool() {
    echo "Verifying Java and keytool accessibility..."
    if command -v java >/dev/null 2>&1 && command -v keytool >/dev/null 2>&1; then
        echo "Java and keytool are accessible."
        java --version
        keytool --version
        return 0
    else
        show_error "Java or keytool is not accessible. You may need to restart your shell or check your installation."
        echo "Current PATH: $PATH"
        echo "Current JAVA_HOME: $JAVA_HOME"
        return 1
    fi
}

# Function to check for and unzip cert file
check_and_unzip_cert() {
    local expectedFile="$HOME/Downloads/ZscalerRootCerts.zip"
    if [[ -f "$expectedFile" ]]; then
        echo "OK: found certs file in download folder"
        unzip -o "$expectedFile"
        echo "Cert file unzipped successfully"
        return 0
    else
        show_error "You must download certs file first: expected $expectedFile."
        return 1
    fi
}

# Function to install cert
install_cert() {
    local expectedCrtFile="ZscalerRootCerts/ZscalerRootCertificate-2048-SHA256.crt"
    if [[ -n "$JAVA_HOME" && -d "$JAVA_HOME" ]]; then
        local outputFile="$JAVA_HOME/bin/ZscalerRootCertificate.der"
        openssl x509 -in "$expectedCrtFile" -inform pem -out "$outputFile" -outform der
        echo "Adding cert to current java instance inside JAVA_HOME at $JAVA_HOME"
        keytool -import -trustcacerts -alias zscalerrootcaChg -file "$outputFile" -keystore "$JAVA_HOME/lib/security/cacerts" -storepass changeit
    else
        show_error "JAVA_HOME is not set or does not point to a valid directory. Skipping Java cert setup."
        echo "JAVA_HOME: $JAVA_HOME"
        return 1
    fi
}

# Function to configure git SSL
configure_git_ssl() {
    echo "Setting git.exe to use local windows CA store"
    git config --global http.sslBackend schannel
}

# Main execution
main() {
    if ! check_admin; then
        exit 1
    fi

    if ! ensure_keytool; then
        exit 1
    fi

    if ! verify_java_keytool; then
        exit 1
    fi

    cd ~
    if ! check_and_unzip_cert; then
        exit 1
    fi

    if ! install_cert; then
        echo "Cert installation skipped or failed."
    fi

    configure_git_ssl

    echo
    echo "Script completed. Final verification:"
    echo "JAVA_HOME: $JAVA_HOME"
    echo "Java version:"
    java --version
    echo "Keytool version:"
    keytool --version
    echo "Git SSL backend:"
    git config --global http.sslBackend
}

# Run the main function
main
