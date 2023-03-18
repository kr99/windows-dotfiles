These are my dotfiles for Windows and git-bash under Windows.

See this article: [Store dotfiles directly in home dir and git repo](https://dev.to/bowmanjd/store-home-directory-config-files-dotfiles-in-git-using-bash-zsh-or-powershell-a-simple-approach-without-a-bare-repo-2if7)

How to do the initial checkout:
```
git init
git remote add origin $REPO

# Execute/uncomment one of the following 2 lines unless a .gitignore with '/**' already exists in the repo
# git config --local status.showUntrackedFiles no
echo '/**' >> .git/info/exclude
```
