. ~/.git-prompt.sh

__autovenv() {
    # Find a virtualenv to activate
    local parent_dir="$PWD"
    local venv=''
    while [ "$parent_dir" != '/' ]; do
        local _venv="$parent_dir/venv"
        if [ -f "$_venv/bin/activate" ]; then
            venv="$_venv"
            break
        fi
        parent_dir="$(dirname "$parent_dir")"
    done

    if [ "$VIRTUAL_ENV" != "$venv" ]; then
        command -v deactivate >/dev/null 2>&1 && deactivate
        if [ -n "$venv" ]; then
            . "$venv/bin/activate"
        fi
    fi
}

__ps1() {
    __autovenv

    local prompt="\u@\h:\w"
    if [ -n "$VIRTUAL_ENV" ]; then
        prompt="($(basename "$VIRTUAL_ENV")) $prompt"
    fi
    __git_ps1 "$prompt" "\\\$ "
}

PROMPT_COMMAND='__ps1'
