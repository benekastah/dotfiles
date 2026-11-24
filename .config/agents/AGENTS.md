# Global instructions for coding agents
How I work in every project, whatever its language. A repo's own AGENTS.md says
what's true of that project, and wins where the two differ. This file lives in
my dotfiles (`.config/agents/AGENTS.md`); Claude Code imports it from its
CLAUDE.md, and Codex reads it through a link.

# General guidance
Don't run `cd` or any command that changes the working directory without
wrapping it in a shell process (so that we return to our original working
directory when the command is done).

Good:
- (cd /some/directory ; do-something)
- git -C /some/directory log
- rg pattern /some/file.txt
Bad:
- cd /some/directory ; do-something
- cd /some/directory ; git log

If you do `cd` into another directory, `cd` back to the original one as soon as
you're done there.

Note: no need to use `git -C` or `make -C` if you are already in the correct
directory. In the case of git, you can be in a subdirectory as well.

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
Use the `review-code` skill for my review preferences when reviewing code.

# Process
- Every prompt ends with an implicit question to you, "Do you have any questions?"
If you have no questions, no need to reply. If you have questions, ask them
before taking action.

# Making changes
Follow the implementation rules in the `implement` skill, including its Java
guidance when applicable. Invoke its delegation workflow for feature
implementation requests even when I don't name the skill, when explicitly
requested, or when the work needs stronger reasoning. Handle routine edits in
this session.
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

Each line of work (a feature, a stack of PRs, an experiment) gets its own git
worktree, so several agents or people can work at once without switching
branches under each other:

```sh
git worktree add ../<repo>-<topic> -b <branch> origin/main
git worktree remove ../<repo>-<topic>    # when done working in it
```

- Leave the main checkout on `main`. An editable install, an editor or another
  session may be running its code; switching its branch changes their code too,
  mid-run.
- One owner per branch. Don't commit or push to a branch another agent is
  working on. Hand it over explicitly, saying what's unpushed and what's in
  flight.
- Remove a worktree you created when you're done working in it, even if its PR
  is still open. Clean up promptly: a branch checked out in a worktree can make
  `git stack restack` and `git stack sync` fail. First check for uncommitted or
  untracked changes and preserve them. Don't remove a worktree someone else is
  using. Keep the branch so a worktree can be created again later.
- Delete scratch space as soon as you're done with it: throwaway clones, renders,
  downloads and their virtualenvs, yours and your subagents' (tell them to). Temp
  directories may be small or held in RAM, and a clone with its venv is hundreds of
  megabytes. Never install from a scratch clone (e.g. a project's `dev.py install`):
  that points my installed commands at something about to be deleted.
- Don't rewrite pushed history someone else may have built on. Add commits, or
  start a new branch and PR, rather than force-pushing a shared branch.
- If we're already in the right repository, check whether I've made a stack for
  the change; if not, offer to make one from the current `main`.

# Stacked PRs with git stack
When a change needs another that isn't merged yet, stack them with [git
stack](https://github.com/benekastah/git-stack), which keeps each branch
rebased on the one below it and each PR pointed at its base. Use the
`git-stack` skill when working with stacks; it points to specialized skills
for syncing, splitting, rearranging and troubleshooting them.

Use `git recommit` only at my request, following the `git-recommit` skill and
its non-interactive CLI instructions.

- Before rebasing, syncing or pushing a branch, check `git stack info` to see
  whether it is tracked and understand its stack. For tracked branches, use
  `git stack restack` or `git stack sync` to rebase and `git stack push` to
  push; never start a plain `git rebase` or use `git push` as a substitute.
  Use `git stack pull` to update locally, or `git stack sync` to update and
  push, instead of `git pull` or `git pull --rebase`. Add `--latest` when the
  stack should move onto the latest root commit.
  After resolving a conflict in a rebase started by git stack, `git rebase
  --continue` is allowed. If git stack cannot perform the operation, stop and
  explain the problem rather than bypassing it with plain Git.
- When using `git recommit` on a tracked branch, first run `git stack info` and
  `git stack ownership show` and respect the ownership and shared-history
  rules above. After `git recommit write`, run `git stack restack` to move
  dependent branches onto the rewritten commits. Don't re-track them first:
  their recorded bases let git stack replay each branch's own commits. If a
  restack conflicts, resolve it, continue the rebase and rerun the restack.
- If a branch isn't tracked, offer to track it (`git stack track main`).
- Get my permission before rearranging a stack. Before pushing or syncing a
  rearranged stack, make sure my permission covers publishing those changes;
  otherwise ask first, even for a draft PR or a stack with no PR yet.
- Before rearranging a branch whose PR targets `main`, is ready to merge and
  has no conflicts so that it no longer targets `main`, warn me that the
  change would delay its merge. If the PR is queued to merge, keep it targeting
  `main`; don't move it onto another branch.
- A stack with no PR yet: when I ask for changes, commit them and run
  `git stack push --prs`.
- A stack whose PR is a draft: push changes freely, unless I say not to.
- A stack whose PR is open for review: offer to push, and wait for my go-ahead.
- After `git stack push --prs` or `git stack prs`, write the description and
  set the labels of each PR it opened.

# From PR to merge
Use the `pr-to-merge` skill when asked to take a change through the PR and
merge workflow, or to review the whole codebase after a run of merges or when
asked. Merging or enqueueing a PR requires my explicit permission.

# Choosing a model
- When recommending an agent model, almost never recommend the highest tier
  (currently Astra or Fable). Prefer a lower tier unless the task exceptionally
  warrants the highest tier.
- In Codex, use Terra at medium effort for the main session by default. When
  implementation or review needs stronger reasoning, delegate it to a subagent
  with a suitable stronger model and effort.
- In Claude Code, use Sonnet 5.5 for the main session and handle ordinary work
  there. Delegate complex implementation and reviews to an Opus 5.5 subagent.
- Honor an explicit model choice and the reviewer-model selection in the review
  skills. Use a fresh reviewer where the review workflow requires one.
- If the needed subagent is unavailable, tell me instead of silently doing its
  higher-reasoning work in the main session. Continue any independent work.

# Google Docs suggested edits
Use the `google-docs-suggestions` skill when asked to suggest an edit to a
Google Doc. Make a native suggestion the user can accept or reject.

# Local instructions
If `~/.local/agents/AGENTS.md` exists, read and follow it as well.
