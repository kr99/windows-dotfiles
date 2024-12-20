These are my dotfiles for Windows and git-bash under Windows.

See this article: [Store dotfiles directly in home dir and git repo](https://dev.to/bowmanjd/store-home-directory-config-files-dotfiles-in-git-using-bash-zsh-or-powershell-a-simple-approach-without-a-bare-repo-2if7)

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
