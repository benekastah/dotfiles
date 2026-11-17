---
name: git-recommit
description: Rebuild or split commits with git recommit's non-interactive CLI when the user requests it.
disable-model-invocation: true
---

# Refactor commits with git recommit

Use [git recommit](https://github.com/benekastah/git-recommit) when the user
asks to rebuild commits or split changes with it. Get the current command-line
options from `git recommit -h` and run `git recommit <subcommand> -h` for each
subcommand before using it. Agents must use its non-interactive CLI, not the
TUI.

1. Check the intended range, worktree, ownership and stack state. Tracked
   uncommitted changes are included; `-u` includes untracked files too. Preserve
   others' work and don't rewrite pushed history someone else may have built on.
   Use `HEAD` as the range to split uncommitted changes.
2. Start a plan with `git recommit start <range>` and inspect it with
   `git recommit show --json`. Use `commit`, `assign`, `unassign` and `edit`
   to shape it.
3. Finish with `git recommit write --validate '<test command>'`, or discard the
   plan with `git recommit abort`. Ensure each resulting commit is independently
   correct and run checks appropriate to the change.
4. For a tracked stack, check `git stack info` and use git stack to restack and
   push affected branches afterwards, following the user's authorization and
   shared-history rules.
