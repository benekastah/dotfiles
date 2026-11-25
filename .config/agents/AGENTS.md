# Global instructions for coding agents
Repo instructions override these where they differ. Also read
`~/.local/agents/AGENTS.md` if present.

# General
- Change directory only in a subshell, e.g. `(cd /path; command)`, and return
  promptly. `git -C` and `make -C` are alternatives, not needed in the right
  directory.
- When adding a dependency, search the web for the latest version; don't rely
  on memory. Be candid and push back when appropriate; I have the final say.
- If you have questions, ask before acting. Otherwise no need to say so.
- Never run `git reset --hard` or skip any git hook without my explicit
  permission. Tell subagents the hook rule too; fix or report hook failures.
- Clean up scratch clones, renders, downloads and virtualenvs, including your
  subagents' (tell them to). Never install from a scratch clone.

# Implementation and review
- Follow `implement` for coding, including its Java guidance when applicable;
  use `review` for review preferences and `split-prs` when splitting PRs.
- Use the current agent and model by default; delegate only on my request. If a
  requested subagent is unavailable, tell me, don't silently substitute the
  current agent, and continue independent work. Honor specified models. Almost
  never recommend the highest tier (currently Astra or Fable).
- Avoid repeated test runs: with `implement` and `review-loop`, prefer final
  tests after a clean review; run focused tests earlier when needed.
- Review before pushing an open non-draft PR or moving a draft out of draft.
- When writing, reviewing or splitting changes, ensure separately deployed
  components are safe when old and new versions run together. Parallel PRs
  must be independently safe to merge and deploy in any order.

# Posting and PRs
- Don't post comments unless I ask or invoke a workflow that posts them; show
  me a draft otherwise. Don't open or comment on GitHub issues without my
  approval. For PR reviews, post all inline findings in one review.
- When posting as me, identify the AI agent and its name on the last line
  unless I explicitly approved the exact text. Approval of the action or
  workflow alone doesn't approve its text.
- Use `pr-to-merge` for that workflow or a whole-code review after merges or on
  request. Merging or enqueueing a PR always requires my explicit permission.
- Use `google-docs-suggestions` for native suggested edits to Google Docs.

# Concurrent work
- When communicating with other agents, consider only open, running sessions;
  never resume historical or unloaded ones just to send a message.
- Give each line of work its own worktree; leave the main checkout on `main`.
  One owner per branch: don't commit or push another agent's branch. Hand over
  ownership explicitly, including unpushed changes and work in flight.
- Promptly remove worktrees you created when done, even with an open PR:
  checked-out branches can block git stack. First check for and preserve uncommitted and
  untracked changes; don't remove a worktree someone else is using. Keep the
  branch for later.
- Don't rewrite pushed history others may have built on. Add commits or start
  a new branch and PR instead of force-pushing a shared branch.
- In the right repo, check for my existing stack; if none, offer one from main.

# Git stack
Use [git stack](https://github.com/benekastah/git-stack) for dependent PRs.
Before rebasing, syncing or pushing, check `git stack info`; for those operations
on tracked branches use git stack, not plain Git, except `git rebase --continue`
after resolving a git stack rebase conflict. Read the `git-stack` skill and
`~/.config/agents/git-stack.md` for my operation and PR rules. Use `git recommit`
only on request; read its skill and the same stack rules. Get my permission
before rearranging a stack and before publishing the rearrangement unless that
permission covers publication. Never move a queued PR off `main`.
