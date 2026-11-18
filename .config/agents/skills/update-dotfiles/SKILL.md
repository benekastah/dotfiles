---
name: update-dotfiles
description: Sync the user's dotfiles (a bare repo whose work tree is $HOME). Commit the general changes made in $HOME, move machine-specific ones into the local files kept out of the repo, pull the remote's changes, then push. Use when the user asks to update, sync, save or push their dotfiles.
---

# Update dotfiles

The dotfiles are a bare repo at `~/.dotfiles` whose work tree is `$HOME`. `config` is git for it
(a function in zsh and fish); where it isn't defined, use
`git --git-dir=$HOME/.dotfiles --work-tree=$HOME`. Run it from `$HOME` (in a subshell) so paths
are relative to the work tree. `~/.github/README.md` explains the repo; read it first.

## 1. Commit what's general, keep what's local out

Look at everything that changed: `config status --short` and `config diff`.

### Search for new files worth adding

`status.showUntrackedFiles` is `no`, so new files never show in `config status`: search for them.
Search where hand-written configuration lives, not all of `$HOME`. List candidates with
`config ls-files --others --exclude-standard -- <path>`. Limit the depth, or use `find` with
`-maxdepth`, so you don't descend into caches. Search:

- top-level dotfiles in `$HOME` (`~/.*rc`, `~/.*profile`, `~/.*.toml`, and the like)
- each tracked directory, recursively (`config ls-files | xargs -n1 dirname | sort -u`), e.g. new
  scripts in `~/bin`, fish functions, nvim plugins, agent skills
- `~/.config/*`, one or two levels deep, for tools with no tracked config yet (a new terminal,
  prompt, editor or CLI config, such as `~/.config/ghostty/config` or `~/.config/starship.toml`)
- `~/.ssh/config` (never keys or `known_hosts`) and other configs the README's tools read

Then judge each candidate. Read it; don't decide from the name alone. Propose a file when it is
hand-written or deliberately edited configuration, or a script meant for every machine: small
text files the user wrote or tuned, often recently modified (`find -newer ~/.dotfiles/HEAD`
helps). Leave out:

- anything an app writes for itself: KDE and other GUI `*rc` state, `fish_variables`,
  `*.json` state, history, caches, lock files, backups, logs, sessions, `mimeapps.list`
- secrets and credentials of any kind
- generated or installed files: links or wrappers to local installs (`~/.local/bin/<tool>` made
  by pip, uv or pipx: scripts of mine live in `~/bin`, which installers never write to), `.desktop` launchers, plugin managers' checkouts and lockfiles unless
  the repo already tracks them
- what's true of this machine alone (see below). Offer the matching local file instead.

A new tool's config can mix both, like a new file. Split it as below. List what you'd add and
why, and what notable files you'd skip, and add only what the user agrees to.

The repo is shared by macOS (zsh, at work) and Linux (fish, at home). Judge each change, hunk by
hunk:

- **General:** how the user wants a tool to behave anywhere. Commit it. If it applies to one OS
  only, guard it the way the repo does (`$OSTYPE` in zsh, `if-shell 'uname | grep -q Darwin'`
  in tmux) rather than leaving it out.
- **Machine-specific:** true of this machine alone. That includes paths to local checkouts or
  installs, hostnames, hardware, an employer's names, hosts, emails or tools, and
  anything secret (tokens, keys, credentials: never commit these). Move it into the local
  file that each config reads if present, which the repo ignores:
  - zsh: `~/.zshenv.local`, `~/.zshrc.local`
  - fish: a file in `~/.config/fish/conf.d/` (not tracked)
  - git: `~/.gitconfig.local`
  - agent instructions: `~/.local/agents/AGENTS.md`; agent skills:
    `~/.local/agents/skills/<name>/`
  - Neovim: the paths `.gitignore` lists
  - anything else: check `~/.gitignore` for a local counterpart. If none exists, ask the user
    before inventing one.

  When one file mixes both, edit it so the tracked file keeps the general part and the local
  file gets the rest. Check the tracked file still loads its local counterpart. Don't use
  `config add -p`: it's interactive.
- **Unsure:** ask, showing the hunk and where you'd put it.

Before committing, show the user the split: what you'll commit, what moved to which local file,
and what you left alone. Then commit in small logical commits whose messages say why. Check the
staged diff (`config diff --cached`) for secrets and machine-specific paths first.

If the change touches a script in `~/bin`, run it once (or its `--help`) to check it still starts.

## 2. Pull

The bare repo has no fetch refspec, so fetch the branch explicitly, then bring local commits on
top:

```sh
config fetch origin main:refs/remotes/origin/main
config rebase origin/main     # fast-forwards when there are no local commits
```

- Resolve any conflict by keeping both sides' intent, then `config rebase --continue`. Never
  `config reset --hard`.
- Checkout refuses to overwrite an untracked file that the remote now tracks. Move it into
  `~/.dotfiles-backup-<date>/` (ignored), retry, and tell the user to compare the two.
- After pulling, if skills under `~/.config/agents/skills` changed, run `install-shared-skills`.
  If shell or tmux config changed, tell the user to restart their shells or reload tmux.

## 3. Push

`config push origin HEAD:main`. If it's rejected because the remote moved, go back to step 2.

Report the commits pushed, what moved to local files, untracked files you left alone and might
be worth tracking, and anything the user must do (restart shells, compare a backup).
