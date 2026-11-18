# CachyOS ships fish defaults (prompt, aliases, fastfetch greeting); use them where installed.
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_DATA_HOME ~/.local/share
set -gx XDG_CACHE_HOME ~/.cache
set -gx EDITOR nvim

switch (uname)
    case Darwin
        # Homebrew, and its GNU coreutils in place of the BSD ones.
        for brew in /opt/homebrew/bin/brew /usr/local/bin/brew
            if test -x $brew
                $brew shellenv | source
                break
            end
        end
        if set -q HOMEBREW_PREFIX; and test -d $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
            fish_add_path --global --path --move $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
        end
end

set -gx PNPM_HOME ~/.local/share/pnpm
fish_add_path --global --path --move ~/bin ~/.local/bin ~/.npm-global/bin $PNPM_HOME

# Claude Code's config, with its CLAUDE.md, which imports ~/.config/agents/AGENTS.md.
set -gx CLAUDE_CONFIG_DIR ~/.config/claude

if status is-interactive
    alias ll 'ls -alF'
    alias la 'ls -A'

    if type -q fzf
        fzf --fish | source
    end
    if test -f ~/.openclaw/completions/openclaw.fish
        source ~/.openclaw/completions/openclaw.fish
    end
end

# What's true of this machine alone goes in an untracked ~/.config/fish/conf.d/*.fish, which
# fish reads before this file.
