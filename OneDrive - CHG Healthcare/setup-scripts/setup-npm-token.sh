#!/bin/bash

# This will extract the npm token (github account) from .npmrc and help you add it to the windows env.

# Function to extract the first authToken from .npmrc
extract_auth_token() {
    local npmrc_path="$HOME/.npmrc"
    if [ -f "$npmrc_path" ]; then
        local auth_token=$(grep --max-count=1 --only-matching --perl-regexp '(?<=_authToken=).*' "$npmrc_path")
        if [ -n "$auth_token" ]; then
            echo "$auth_token"
            return 0
        fi
    fi
    return 1
}

# Function to copy text to clipboard
copy_to_clipboard() {
    echo -n "$1" | clip.exe
}

# Function to open Windows Environment Variables settings
open_env_variables_settings() {
    rundll32.exe sysdm.cpl,EditEnvironmentVariables
}

# Extract the authToken
AUTH_TOKEN=$(extract_auth_token)

if [ -z "$AUTH_TOKEN" ]; then
    echo "Error: Could not find authToken in .npmrc file."
    exit 1
fi

# Copy AUTH_TOKEN to clipboard
copy_to_clipboard "$AUTH_TOKEN"

echo "The NPM_TOKEN has been copied to your clipboard."
echo "Variable Name: NPM_TOKEN"
echo "Variable Value: $AUTH_TOKEN"
echo ""
echo "The Environment Variables settings will now open."
echo "Please add a new System Variable with the above name and value."
echo ""
echo "Press any key to continue..."
read -n 1 -s

# Open Environment Variables settings
open_env_variables_settings

echo ""
echo "After setting the variable, remember to restart any applications (including IntelliJ IDEA) for the changes to take effect."
