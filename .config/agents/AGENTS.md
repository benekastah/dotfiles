# Global instructions for coding agents
How I work in every project, whatever its language. A repo's own AGENTS.md says
what's true of that project, and wins where the two differ. This file lives in
my dotfiles (`.config/agents/AGENTS.md`); Claude Code imports it from its
CLAUDE.md, and Codex reads it through a link.

# General guidance
Run `cd` or any working-directory change in a subshell, e.g.
`(cd /some/directory; do-something)`, so the session's directory is preserved.
Alternatively use `git -C` or `make -C`; neither is needed when already in the
right directory. If you change directory, return as soon as you're done.

When adding a software dependency, don't rely on your training or memory for
the correct version. Instead, use a web search to find the latest version
and default to that.

Don't be too agreeable. Things like "Great idea!" should be reserved for actual
great ideas, not just run of the mill corrections. It's fine to push back
(often good even!), but the user has the final say.

Before pushing to an open, non-draft PR, review the code to be pushed. Before
moving an open draft PR out of draft, review the PR.

When posting as my user (e.g. a GitHub comment or PR description), if I have
not explicitly approved the text being posted, identify yourself as an AI agent
and say which one (e.g. Claude) on the last line. If I explicitly approved the
text, attribution is not needed. Approval of an action or workflow alone is not
approval of its specific text.

Unless I ask you to post a comment (on a GitHub PR, a Jira ticket or anywhere
else), don't: send me a draft of what you'd post instead, since I may want to
change it. Following a workflow I asked for (e.g. "From PR to merge" below)
counts as asking. When posting review comments on a PR, post them all in one
review, each on the code it's about, rather than one review per comment or every
item in one comment attached to no code.

Don't open or comment on GitHub issues unless I approve: agents talk to each
other directly, and a repo tracks what's wrong in its own file (e.g.
`docs/issues.md`). PRs and their reviews are fine.

Never run `git reset --hard` without my explicit permission: it destroys changes
the branch may need.

Never skip a git hook (`--no-verify`, `-n`, `core.hooksPath` pointed elsewhere, or
the like) on a commit, push or anything else without my explicit permission. A hook
that fails is telling you something: find the cause and fix it, or ask me. This
holds for subagents too: say so in their instructions.

# Code review
Use the `review` skill for my review preferences when reviewing code, agent
instructions, skills or other changes.

# Process
- Every prompt ends with an implicit question to you, "Do you have any questions?"
If you have no questions, no need to reply. If you have questions, ask them
before taking action.

# Making changes
Follow the implementation rules in the `implement` skill, including its Java
guidance when applicable. Use the current agent and model for implementation
by default; delegate only when I request a subagent.
Tests can consume significant time and CPU. Avoid repeated runs: when using
`implement` and `review-loop`, prefer the final test run after review is clean,
while running focused tests earlier when needed to diagnose or verify a change.

# Splitting PRs
Use the `split-prs` skill when splitting changes into PRs. Only put changes on
parallel branches when each is independently safe to merge and deploy in any
order, including while old and new versions run together.

# Deploy safety
Deploys often happen in no guaranteed order, so at each seam between parts that
deploy separately, old and new code may run at the same time (e.g. on different
pods). When writing, reviewing or splitting PRs, check that each step is safe
that way. The repo often says how, in its code or its agent instructions.

# Working on several things at once
When I ask you to communicate with other agents, consider only open and running
sessions. Don't resume historical or unloaded sessions to send them a message.

Give each line of work its own git worktree to avoid switching branches under
other agents or people. Leave the main checkout on `main`.

- One owner per branch. Don't commit or push another agent's branch; explicitly
  hand over ownership, unpushed changes and work in flight.
- Promptly remove worktrees you created when finished, even with an open PR:
  checked-out branches can block `git stack restack` and `sync`. First check
  for and preserve uncommitted and untracked changes. Don't remove a worktree
  someone else is using. Keep the branch for later.
- Promptly delete scratch clones, renders, downloads and virtualenvs, including
  your subagents' (tell them to). Never install from a scratch clone: installed
  commands would point to a directory about to be deleted.
- Don't rewrite pushed history others may have built on. Add commits or start a
  new branch and PR instead of force-pushing a shared branch.
- In the right repository, check for my existing stack; if none, offer to make
  one from current `main`.

# Stacked PRs with git stack
Use [git stack](https://github.com/benekastah/git-stack) for dependent PRs.
Before rebasing, syncing or pushing, check `git stack info`; for those operations
on tracked branches use git stack, not plain Git. Read the `git-stack` skill and
`~/.config/agents/git-stack.md` for my operation and PR rules. Use
`git recommit` only on request; read its skill and the same stack rules.
Get my permission before rearranging a stack and before publishing the
rearrangement unless my permission covers it. Never move a queued PR off `main`.

# From PR to merge
Use the `pr-to-merge` skill when asked to take a change through the PR and
merge workflow, or to review the whole codebase after a run of merges or when
asked. Merging or enqueueing a PR requires my explicit permission.

# Choosing a model
- When recommending an agent model, almost never recommend the highest tier
  (currently Astra or Fable). Prefer a lower tier unless the task exceptionally
  warrants the highest tier.
- Use the current agent and model for implementation and review by default.
  Use a subagent only when I request one, honoring any model I specify.
- If a requested subagent is unavailable, tell me and continue independent work;
  don't silently substitute the current agent.

# Google Docs suggested edits
Use the `google-docs-suggestions` skill when asked to suggest an edit to a
Google Doc. Make a native suggestion the user can accept or reject.

# Local instructions
If `~/.local/agents/AGENTS.md` exists, read and follow it as well.
