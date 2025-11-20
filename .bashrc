# ============================================
# TIMING (for debugging - can remove later)
# ============================================
echo "BASHRC START: $(date +%T.%N)"

# ============================================
# INTERACTIVE CHECK
# ============================================
case $- in
  *i*) ;;
    *) return;;
esac

# ============================================
# SHELL OPTIONS & BEHAVIOR
# ============================================
# Vi mode
set -o vi

# Better history
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Case-insensitive completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# Correct minor spelling errors in cd
shopt -s cdspell
shopt -s checkwinsize

# ============================================
# GIT PROMPT CONFIG (for system __git_ps1)
# ============================================
export GIT_PS1_SHOWDIRTYSTATE=""
export GIT_PS1_SHOWSTASHSTATE=""
export GIT_PS1_SHOWUNTRACKEDFILES=""
export GIT_PS1_SHOWUPSTREAM=""

# ============================================
# LAZY LOADED COMPLETIONS
# ============================================
# Git completion (lazy loaded)
git() {
    if [ -z "$GIT_COMPLETION_LOADED" ]; then
        for completion in \
            "/usr/share/git/completion/git-completion.bash" \
            "/mingw64/share/git/completion/git-completion.bash"
        do
            if [ -f "$completion" ]; then
                source "$completion"
                break
            fi
        done
        export GIT_COMPLETION_LOADED=1
    fi
    command git "$@"
}

# ============================================
# LAZY LOADED TOOLS
# ============================================
# NODIST
node() {
    if [ -z "$NODIST_LOADED" ]; then
        NODIST_BIN_DIR__=$(echo "$NODIST_PREFIX" | sed -e 's,\\,/,g')/bin
        if [ -f "$NODIST_BIN_DIR__/nodist.sh" ]; then 
            . "$NODIST_BIN_DIR__/nodist.sh"
        fi
        unset NODIST_BIN_DIR__
        export NODIST_LOADED=1
    fi
    command node "$@"
}

npm() {
    node -v > /dev/null 2>&1  # Trigger node lazy load
    command npm "$@"
}

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
sdk() {
    if [ -z "$SDKMAN_LOADED" ]; then
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
        export SDKMAN_LOADED=1
    fi
    command sdk "$@"
}

# ============================================
# EDITOR
# ============================================
gvimLoc='/c/Windows/gvim.bat'
export EDITOR="$gvimLoc"

# ============================================
# ALIASES
# ============================================
alias vi="$gvimLoc"
alias vim="$gvimLoc"
alias view="$gvimLoc -R"
alias vimdiff="$gvimLoc -d"
alias gvim="$gvimLoc"
alias gvimdiff="$gvimLoc -d"

alias ls='ls -F --color=auto --show-control-chars'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias prune='git branch --merged main | grep -v "^[ *]*main$" | xargs git branch -d'

# Load git completion immediately (it's fast!)
for completion in \
    "/usr/share/git/completion/git-completion.bash" \
    "/mingw64/share/git/completion/git-completion.bash"
do
    if [ -f "$completion" ]; then
        source "$completion"
        break
    fi
done

# ============================================
# NPM COMPLETIONS & ALIASES
# ============================================
eval "$(npm completion)"


# ZSH-like completion: list on first tab, cycle on subsequent tabs
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind '"\t":menu-complete'                      # TAB cycles
bind '"\e[Z":menu-complete-backward'           # Shift-TAB cycles backward

# ============================================
# STARSHIP PROMPT
# ============================================
eval "$(starship init bash)"

echo "BASHRC END: $(date +%T.%N)"export PATH=$HOME/bin:$PATH

# --- Starship & Git Bash Fixes ---
export LANG=en_US.UTF-8
export TERM=xterm

# autocomplete with fuzzy finder fzf
# Enable fzf history search with Ctrl+R
export FZF_DEFAULT_COMMAND='history'
echo "Ctrl-R to search history/etc"


# Initialize Starship prompt
eval "$(starship init bash)"
