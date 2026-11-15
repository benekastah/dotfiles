# Environment for every zsh, interactive or not (scripts and agents too). .zprofile runs this
# again on macOS, whose /etc/zprofile reorders PATH for login shells.

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export EDITOR=nvim

typeset -U path  # no duplicates: the first of each stays

if [[ $OSTYPE == darwin* ]]; then
    # Homebrew, and its GNU coreutils in place of the BSD ones.
    for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [[ -x $brew ]]; then
            eval "$("$brew" shellenv)"
            break
        fi
    done
    if [[ -n $HOMEBREW_PREFIX && -d $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin ]]; then
        path=("$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" $path)
        manpath=("$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman" $manpath)
    fi
fi

export PNPM_HOME="$HOME/.local/share/pnpm"
path=("$HOME/bin" "$HOME/.local/bin" "$HOME/.npm-global/bin" "$PNPM_HOME" $path)

[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"
[[ -f $HOME/.ghcup/env ]] && . "$HOME/.ghcup/env"
[[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"

# What's true of this machine alone.
[[ -f $HOME/.zshenv.local ]] && . "$HOME/.zshenv.local"
