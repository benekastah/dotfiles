#!/bin/bash

if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Stuff I made myself
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


alias history-reset='history -a; history -c; history -r'

alias ipython='python -m IPython'

export TODO_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/todo/todo.cfg"
alias todo='todo.sh -d "$TODO_CONFIG"'
