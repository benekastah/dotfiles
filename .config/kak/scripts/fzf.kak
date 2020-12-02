# https://github.com/mawww/kakoune/wiki/Fuzzy-finder#fzf
def -override -docstring 'Invoke fzf to open a file' -params 0 find %{
    evaluate-commands %sh{
        if [ -z "${kak_client_env_TMUX}" ]; then
            printf 'fail "client was not started under tmux"\n'
        else
            function findfiles() {
                # First, try searching all git-reachable files.
                git ls-tree -r HEAD --name-only || \
                # If this isn't a git repo, search for files from the current
                # directory, ignoring vendor files and build artifacts.
                find . -type d \( \
                    -path ./venv -o \
                    -path ./node_modules -o \
                    -path ./build -o \
                    -path ./.git \
                \) -prune -o \
                -type f -print
            }
            file="$(findfiles |TMUX="${kak_client_env_TMUX}" fzf-tmux -d 15)"
            if [ -n "$file" ]; then
                printf 'edit "%s"\n' "$file"
            fi
        fi
    }
}

map global user f ': find<ret>' -docstring 'Find file using fzf'

# the original version no longer works since kak_buflist is no longer ":" separated.
# this one works if you don't have single quote in file names.

def -override -docstring 'invoke fzf to select a buffer' \
  find-buffer %{eval %sh{
      BUFFER=$(printf %s\\n ${kak_buflist} | sed "s/'//g" |fzf-tmux -d 15)
      if [ -n "$BUFFER" ]; then
        echo buffer ${BUFFER}
      fi
} }

alias global findb find-buffer

def -override -docstring 'Invoke fzf to open a file' -params 0 read %{
    execute-keys %sh{
        if [ -z "${kak_client_env_TMUX}" ]; then
            printf 'fail "client was not started under tmux"\n'
        else
            file="$(find . -type f |TMUX="${kak_client_env_TMUX}" fzf-tmux -d 15)"
            if [ -n "$file" ]; then
                echo '!' cat "$file" '<ret>'
            fi
        fi
    }
}

alias global r read


map global normal <c-p> :<space>find<ret> -docstring 'Find a file'
