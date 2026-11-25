---
name: implement
description: Implement a request using the current agent or a requested subagent, with the appropriate stack and worktree.
---

# Implement

1. Identify the implementation request, desired outcome and any requested
   follow-up. Ask for clarification needed to implement it. Use the current
   agent and model by default; delegate only when the user requests a subagent.
   If a subagent is requested without a model, ask which model to use, offering
   available choices and a suitable recommendation. Wait for the answer.
2. Inspect the repository's instructions, branch, worktree status, ownership
   and `git stack info`. Use an existing branch and stack intended for this work
   only when available to its owner. Don't disturb another agent's work or use
   an existing worktree without checking ownership and unfinished changes. If
   the target or ownership is unclear, ask. Otherwise, offer a new stack from
   the appropriate base and use a fresh worktree. Follow the user's worktree,
   git stack, rearrangement and published PR instructions.
3. Implement the request using the rules below. Keep documentation current,
   plan appropriate tests, and commit in logical steps. Reserve requested
   follow-up and publishing required by standing instructions until after the
   review loop. Defer routine test runs to `review-loop`; run focused tests
   earlier when needed to diagnose or verify a change.
   If the user requested a subagent, use the selected model and choose a fork
   or fresh subagent as appropriate. Give it the request, decisions, target,
   applicable instructions and these implementation rules; tell it not to
   execute the reserved follow-up or skip a git hook without explicit user
   permission. If it is unavailable, tell the user and continue independent work
   without silently substituting yourself. Have it report commits, checks,
   outstanding work and blockers, and hand back branch and worktree ownership.
4. Verify the implementation and checks needed for handoff, then invoke
   `review-loop` using the current agent and model unless the user requests a
   reviewer subagent. Pass the worktree, branch, review scope, planned tests,
   earlier test results, unresolved failures and requested or standing follow-up.
   Let `review-loop` carry out the follow-up after a clean review. When finished
   with a worktree created for this task, check and preserve uncommitted and
   untracked changes before removing it; never remove a worktree someone else is
   using. Report the result, commits, checks and remaining issues.

# Implementation rules

Read the review preferences in the `review` skill when implementing and
instruct any requested implementation subagent to do the same. Reading these preferences
provides context and does not itself start the review workflow.

- One kind of change per PR. A refactor, a new feature and a fix are separate
  PRs. When one change needs another first, land that first, on its own, with
  its own tests, and stack the PR on it (see the `git-stack` skill).
- Keep PRs small enough to review well. Follow the `split-prs` skill when
  splitting a change, including its guidance on dependencies and deployment.
- Keep the docs up to date as you code, in the same commit as the change, not
  in a docs pass afterwards: the README for behavior, the repo's AGENTS.md for
  the shape of the code and its rules, and the docstrings and comments on the
  code you touch. Before committing, search the docs for the names you renamed,
  moved or removed.
- Never change changelog entries for prior versions. Add new entries under the
  upcoming release section.
- Ask before adding a runtime dependency; prefer the standard library.
- Work test-first: write tests for a change or bug before implementing it.
  When useful to verify the test or diagnose a change, run a focused test first
  and check that it fails for the expected reason. For the implementation workflow,
  otherwise pass the test plan to `review-loop` for the final run. Follow
  applicable limits on local test duration and report tests deferred to CI.
- Every change to behavior comes with tests, in the same commit, and changes
  the tests that cover the old behavior. Make sure each would fail without the
  change.
- Commit the code I ask you to write, in small, logical steps whose messages
  say why, not just what, and tell me the commits you made, since I'll want to
  review them. The checks must pass on a PR's last commit.
- Running tests is good, but a long full run taxes my machine, and CI runs it
  anyway: when the tests take more than about 30 seconds, run the ones near the
  change and leave the full run to CI, unless the repo says otherwise.

For Java changes, read [Java guidance](references/java.md).
