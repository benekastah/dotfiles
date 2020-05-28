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

__reset() {
    echo -n '\['
    tput sgr0
    echo -n '\]'
}

__bg-color() {
    echo -n '\['
    tput setab $1
    echo -n '\]'
}

__fg-color() {
    echo -n '\['
    tput setaf $1
    echo -n '\]'
}

__bold() {
    echo -n '\['
    tput bold
    echo -n '\]'
}

__ps1() {
    __autovenv

    local prompt="\u@\h:\w"
    if [ -n "$VIRTUAL_ENV" ]; then
        prompt="($(basename "$VIRTUAL_ENV")) $prompt"
    fi

    local after_prompt="\\\$ "

    local num_todos="$(todo ls @fuji | head -n -2 | wc -l)"
    local todo="$(__bold)$(__fg-color 3)$num_todos$(__reset)$(__fg-color 3) todo(s)$(__reset)"
    after_prompt=" $todo$after_prompt"

    __git_ps1 "$prompt" "$after_prompt"
}

export PROMPT_COMMAND="__ps1; $PROMPT_COMMAND"
