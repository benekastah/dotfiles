# Vim-like shortcuts
# 
# These definitions seem weird, but they match vim's behavior
def -override -docstring 'Open a new horizontal editor pane' -params 0 hsplit %{
    evaluate-commands %sh{
        echo tmux-terminal-vertical kak -c "$kak_session"
    }
}

def -override -docstring 'Open a new vertical editor pane' -params 0 vsplit %{
    evaluate-commands %sh{
        echo tmux-terminal-horizontal kak -c "$kak_session"
    }
}

def -override -docstring 'Open a new editor window' -params 0 tabe %{
    evaluate-commands %sh{
        echo tmux-terminal-window kak -c "$kak_session"
    }
}

alias global split hsplit
alias global s hsplit
alias global vs vsplit
alias global qa kill
alias global qa! kill!
alias global bd delete-buffer
alias global bd! delete-buffer!

alias global tag ctags-search
map global user ] :ctags-search<ret> -docstring 'Ctags search'

map global normal = |$kak_opt_formatcmd<ret> -docstring 'Format selected code'

def -docstring 'Format paragraphs' -override \
  format-paragraphs %{
    execute-keys '|if [ -n "$kak_opt_comment_line" ] && [[ $(echo "$kak_selection" | sed ''s/^[[:space:]]*//'') = "$kak_opt_comment_line"* ]]; then fmt -w80 -u -p "$kak_opt_comment_line"; else fmt -w80 -u; fi<ret>'
  }
map global user q :format-paragraphs<ret> -docstring 'Format selection into readable paragraphs'

alias global help doc
alias global h doc
