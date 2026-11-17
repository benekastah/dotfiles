# The dotfiles repo is a bare repo whose work tree is $HOME: `config status`, `config add`.
# An autoloaded function, so non-interactive fish (scripts, agents) has it too.
function config --wraps git --description 'git for the dotfiles repo'
    command git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
end
