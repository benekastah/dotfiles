
_style() { echo -En "\e[$1m$2\e[0m" ; }

_reset() { _style 0 "$1" ; }
_bold() { _style 1 "$1" ; }
_dim() { _style 2 "$1" ; }
_underlined() { _style 4 "$1" ; }
_invert() { _style 7 "$1" ; }

_fg_default() { _style 39 "$1" ; }
_fg_black() { _style 30 "$1" ; }
_fg_red() { _style 31 "$1" ; }
_fg_green() { _style 32 "$1" ; }
_fg_yellow() { _style 33 "$1" ; }
_fg_blue() { _style 34 "$1" ; }
_fg_magenta() { _style 35 "$1" ; }
_fg_cyan() { _style 36 "$1" ; }
_fg_light_gray() { _style 37 "$1" ; }
_fg_dark_gray() { _style 90 "$1" ; }
_fg_light_red() { _style 91 "$1" ; }
_fg_light_green() { _style 92 "$1" ; }
_fg_light_yellow() { _style 93 "$1" ; }
_fg_light_blue() { _style 94 "$1" ; }
_fg_light_magenta() { _style 95 "$1" ; }
_fg_light_cyan() { _style 96 "$1" ; }
_fg_white() { _style 107 "$1" ; }

_bg_default() { _style 49 "$1" ; }
_bg_black() { _style 40 "$1" ; }
_bg_red() { _style 41 "$1" ; }
_bg_green() { _style 42 "$1" ; }
_bg_yellow() { _style 43 "$1" ; }
_bg_blue() { _style 44 "$1" ; }
_bg_magenta() { _style 45 "$1" ; }
_bg_cyan() { _style 46 "$1" ; }
_bg_light_gray() { _style 47 "$1" ; }
_bg_dark_gray() { _style 100 "$1" ; }
_bg_light_red() { _style 101 "$1" ; }
_bg_light_green() { _style 102 "$1" ; }
_bg_light_yellow() { _style 103 "$1" ; }
_bg_light_blue() { _style 104 "$1" ; }
_bg_light_magenta() { _style 105 "$1" ; }
_bg_light_cyan() { _style 106 "$1" ; }
_bg_white() { _style 107 "$1" ; }

_git_ahead_behind() {
    _local="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    remote="$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))"
    if [ -z $_local ] || [ -z $remote ]; then
        return 0
    fi
    tmp="$(git rev-list --left-right ${_local}...${remote} -- 2>/dev/null)"
    if echo "$tmp" | grep '^<' -q; then
        echo -n '<'
    fi
    if echo "$tmp" | grep '^>' -q; then
        echo -n '>'
    fi
    if [ -z "$result" ]; then
        echo -n '='
    fi
}

_if_git() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        printf "$1"
    fi
}

_git_status() {
    status="$(git status --porcelain 2>/dev/null)"
    if echo "$status" | grep '^??' -q; then
        echo -n '%'
    fi
    if echo "$status" | grep '^M' -q; then
        echo -n '+'
    fi
    if echo "$status" | grep '^\s\+M' -q; then
        echo -n '*'
    fi
}

_git_prompt() {
    _reset "\$(_if_git ' (')"
    _fg_blue "\$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    _fg_red "\$(_git_status)"
    _fg_red "\$(_git_ahead_behind 2>/dev/null)"
    _reset "\$(_if_git ')')"
}

_prompt() {
    _reset "\u@\h:\w"
    _git_prompt
    _bold " $ "
}

PS1="$(_prompt)"
