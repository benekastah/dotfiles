# dotfiles

My config for macOS (zsh, at work) and Linux (fish, at home): zsh and fish, tmux, Neovim,
git, a few scripts in `.local/bin/`, and the instructions every coding agent gets
(`.config/agents/AGENTS.md`).

## Setting up a machine

The repo is a bare repo whose work tree is `$HOME`, so each file is where it's used, with no
links or install step:

```sh
git clone --bare git@github.com:benekastah/dotfiles.git ~/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
```

(`~/.local/bin/set-up-dotfiles.sh` does the same.) Checkout stops on a file that's already there:
move it aside and check out again. Then `config` (an alias in both shells) is git for this
repo: `config status`, `config add ~/.config/fish/config.fish`, `config commit`. It shows only
the files it tracks.

## One repo for macOS and Linux

- A file only one system uses (KDE's `kcminputrc`, the REAPER launcher) is just tracked; the
  other system ignores it.
- Where a file needs to differ, it checks the system itself: `switch (uname)` in fish,
  `$OSTYPE` in zsh, `if-shell 'uname | grep -q Darwin'` in tmux.
- What's true of one machine alone stays out of the repo, in a file each shell reads if it's
  there: `~/.config/fish/conf.d/*.fish`, `~/.zshenv.local`, `~/.zshrc.local`, and
  `~/.gitconfig.local` for git.

## Coding agents

`.config/agents/AGENTS.md` is how I want agents to work in every project. Claude Code reads it
through `.claude/CLAUDE.md`, an import (and `.config/claude/CLAUDE.md`, a link to it, where
`CLAUDE_CONFIG_DIR` is `~/.config/claude`), and Codex through `.codex/AGENTS.md`, a link.
