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
# PATH
# ============================================
export PATH=$HOME/bin:$PATH

# ============================================
# ENVIRONMENT
# ============================================
export LANG=en_US.UTF-8
export TERM=xterm

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

# History expansion
bind Space:magic-space                    # Preview expansion before executing
shopt -s histverify                       # Confirm before executing expansion

# Autocorrect directory typos
shopt -s dirspell                         # Correct typos in directory names

# Better globbing
shopt -s globstar                         # ** matches recursively (e.g., **/*.js)
shopt -s nocaseglob                       # Case-insensitive globbing
shopt -s extglob                          # Extended pattern matching

# Better job control
shopt -s checkjobs                        # Warn about stopped jobs on exit

# Programmable completion
shopt -s progcomp                         # Enable programmable completion

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
function git {
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
function node {
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

function npm {
    node -v > /dev/null 2>&1  # Trigger node lazy load
    if [ -z "$NPM_COMPLETION_LOADED" ]; then
        eval "$(command npm completion 2>/dev/null)"
        export NPM_COMPLETION_LOADED=1
    fi
    command npm "$@"
}

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
function sdk {
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

# ============================================
# TAB COMPLETION BEHAVIOR
# ============================================
# ZSH-like completion: list on first tab, cycle on subsequent tabs
bind "set menu-complete-display-prefix on"
bind '"\t":menu-complete'
bind '"\e[Z":menu-complete-backward'

# ============================================
# FZF
# ============================================
export FZF_DEFAULT_COMMAND='history'
echo "Ctrl-R to search history/etc"

# ============================================
# STARSHIP PROMPT
# ============================================
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init bash)"
else
    echo "Warning: starship not found in PATH"
fi

echo "BASHRC END: $(date +%T.%N)"

