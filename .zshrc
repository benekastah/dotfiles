# Interactive zsh: history, completion, the prompt and aliases. The environment is in .zshenv.

# CachyOS ships zsh defaults (prompt, plugins); use them where installed, and set ours after.
if [[ -f /usr/share/cachyos-zsh-config/cachyos-config.zsh ]]; then
    source /usr/share/cachyos-zsh-config/cachyos-config.zsh
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_dups hist_ignore_space extended_history interactive_comments
export WORDCHARS='*?_.[]~&;!#$%^(){}<>'
export ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

autoload -Uz compinit && compinit

# user@host:dir branch%
autoload -Uz vcs_info
precmd_functions+=(vcs_info)
zstyle ':vcs_info:git:*' formats ' %b'
zstyle ':vcs_info:git:*' actionformats ' %b|%a'
setopt prompt_subst
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f${vcs_info_msg_0_}%# '

if ls --color=auto -d . > /dev/null 2>&1; then
    alias ls='ls --color=auto'  # GNU ls (Linux, or Homebrew's coreutils on macOS)
else
    alias ls='ls -G'  # BSD ls
fi
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi
if (( $+commands[pyenv] )); then
    eval "$(pyenv init -)"
fi

# Keep the ssh agent's socket at one path, so shells inside a tmux session that outlives the
# login still reach it after reconnecting.
sock="/tmp/ssh-agent-$USER-tmux"
if [[ -n $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != "$sock" ]]; then
    ln -sf "$SSH_AUTH_SOCK" "$sock"
    export SSH_AUTH_SOCK="$sock"
fi
unset sock

# What's true of this machine alone.
[[ -f $HOME/.zshrc.local ]] && . "$HOME/.zshrc.local"
