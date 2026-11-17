---
name: git-recommit
description: Rebuild or split commits with git recommit's non-interactive CLI when the user requests it.
disable-model-invocation: true
---

# Refactor commits with git recommit

Use [git recommit](https://github.com/benekastah/git-recommit) when the user asks to rebuild commits or split changes with it. Read its documentation and subcommand help first. Agents must use its non-interactive CLI, not the TUI.

Check the intended range, worktree, ownership and stack state before starting. Tracked uncommitted changes are included; `-u` includes untracked files too. Preserve others' work and don't rewrite pushed history someone else may have built on. Use `HEAD` as the range to split uncommitted changes.

Start a plan with `git recommit start <range>`, inspect it with `git recommit show --json`, and use `commit`, `assign`, `unassign` and `edit` to shape it. Finish with `git recommit write --validate '<test command>'`, or discard the plan with `git recommit abort`. Ensure each resulting commit is independently correct and run checks appropriate to the change.

For a tracked stack, check `git stack info` and use git stack to restack and push affected branches afterwards, following the user's authorization and shared-history rules.
