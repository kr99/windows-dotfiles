# Setup fzf
# ---------
if [[ ! "$PATH" == */c/Users/kirobins/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/c/Users/kirobins/.fzf/bin"
fi

eval "$(fzf --bash)"
