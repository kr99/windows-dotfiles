These are my dotfiles for Windows and git-bash under Windows.

See this article: [Store dotfiles directly in home dir and git repo](https://dev.to/bowmanjd/store-home-directory-config-files-dotfiles-in-git-using-bash-zsh-or-powershell-a-simple-approach-without-a-bare-repo-2if7)

GPT claude sonnet generated this one-go script.  Let's try it next time, shall we?
```# bootstrap.ps1
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Check Windows Updates first
Write-Host "`nIMPORTANT: Windows Updates should be run first." -ForegroundColor Yellow
start ms-settings:windowsupdate
$response = Read-Host "Have you started Windows Updates? (y/n)"
if ($response -ne 'y') {
    Write-Host "Please run Windows Updates first. Script will exit."
    exit 1
}

# Install chocolatey if not present
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "`nInstalling Chocolatey..."
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Install required tools
Write-Host "`nInstalling required tools..."
choco install --yes git gow curl openssh rsync

# Always show backup instructions first
Write-Host "`nTo backup SSH keys to OneDrive, run these commands on your source machine:"
Write-Host "mkdir -p `"$env:OneDrive/SSH-Backup`""
Write-Host "cp ~/.ssh/id_rsa* `"$env:OneDrive/SSH-Backup/`""

# SSH Key handling
Write-Host "`nSSH Key Options for this machine:"
Write-Host "1. Generate new SSH key and open GitHub"
Write-Host "2. Copy existing SSH key from OneDrive"

$keyChoice = Read-Host "`nSelect option (1-2)"

switch ($keyChoice) {
    "1" {
        if (!(Test-Path "~/.ssh/id_rsa")) {
            ssh-keygen -t rsa -b 4096 -C "kimball.robinson@chghealthcare.com" -f "$HOME/.ssh/id_rsa" -N '""'
            Get-Content "$HOME/.ssh/id_rsa.pub" | clip
            Write-Host "`nPublic SSH key copied to clipboard."
            Start-Process "https://github.com/settings/keys"
            Write-Host "Press Enter after adding the key to GitHub..."
            Read-Host
        }
    }
    "2" {
        Write-Host "`nTo copy from OneDrive, run these commands:"
        Write-Host "mkdir -p ~/.ssh"
        Write-Host "cp `"$env:OneDrive/SSH-Backup/id_rsa`" ~/.ssh/"
        Write-Host "cp `"$env:OneDrive/SSH-Backup/id_rsa.pub`" ~/.ssh/"
        Write-Host "chmod 600 ~/.ssh/id_rsa"
        $proceed = Read-Host "`nHave you copied the SSH keys? (y/n)"
        if ($proceed -ne 'y') {
            Write-Host "Please copy SSH keys before continuing. Script will exit."
            exit 1
        }
    }
    default {
        Write-Host "Invalid option. Script will exit."
        exit 1
    }
}

# Clone dotfiles
Write-Host "`nCloning dotfiles..."
$env:REPO="git@github.com:kr99/windows-dotfiles.git"
$env:BRANCH="main"

git init
git config --local status.showUntrackedFiles no
git remote add origin $env:REPO
git fetch --set-upstream origin $env:BRANCH
git switch --no-overwrite-ignore $env:BRANCH

Write-Host "`nSetup complete!"
```

<details>
    <summary>Manually - what we might need to do instead.  Old version</summary>
First, you need chocolatey, git, git bash, and gow.  In powershell, as an admin:
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install --yes git gow curl openssh
```

You will need to generate a new ssh key from github.  It's a pain.
* git bash: `ssh-keygen -t rsa -b 4096 -C "kimball.robinson@chghealthcare.com"`
* git bash: `clip < ~/.ssh/id_rsa.pub`
* https://github.com/settings/keys
* 

How to do the initial checkout:
```
export REPO=git@github.com:kr99/windows-dotfiles.git
export BRANCH=main

git init
git config --local status.showUntrackedFiles no
git remote add origin $REPO
git fetch --set-upstream origin $BRANCH
git switch --no-overwrite-ignore $BRANCH # Complains if files of same name already exist
#git switch -f $BRANCH # Only do this if you are comfortable overwriting existing files
```

Now, only files you target will be added/updated.

To add modified files:
```
git add -u
```
To add a file, you will be prompted to use -F to force add an ignored file.

Now, start git-bash **as admin**
```
cd setup-scripts
bash ./install.sh
```
</details>
