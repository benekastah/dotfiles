---
name: implement
description: Delegate an implementation request to a selected subagent model, using the appropriate existing stack or a new worktree and stack.
---

# Implement

1. Identify the implementation request, desired outcome and any requested
   follow-up from the arguments and conversation. Ask the user for any
   clarification needed to implement it. If the subagent model wasn't specified,
   ask which model to use, offering models available to the current agent and
   recommending one suited to the task. Wait for the model choice and any
   answers needed before starting dependent work.
2. Inspect the repository's instructions, branch, worktree status, ownership
   and `git stack info`. If the current branch and stack are already intended
   for this work and available to the subagent, hand them over explicitly. Don't
   disturb another agent's work or use an existing worktree without checking its
   ownership and unfinished changes. If the target or ownership is unclear, ask.
   Otherwise, offer a new stack from the appropriate base and use a fresh
   worktree, following the user's worktree and git stack instructions. Respect
   the rules for independent changes, stack rearrangements and published PRs.
3. Delegate the implementation to a subagent using the selected model. Give it
   the user's request, decisions, target worktree and branch, and applicable
   instructions. Reserve requested follow-up and publishing required by standing
   instructions for after the review loop; tell the subagent not to execute
   them. Have it follow the implementation rules below directly rather than
   invoking `implement` again. Tell it never to skip a git hook without the
   user's explicit permission. It implements the change, keeps docs
   current, follows test-first and commit instructions, plans appropriate tests,
   and reports commits, checks, outstanding work and any blockers. Defer routine
   test runs to `review-loop`; run focused tests earlier when needed to diagnose
   or verify a change. If delegation
   is unavailable, tell the user and continue independent work; don't silently
   implement the delegated work in the main session.
4. Have the subagent hand back ownership of the branch and worktree, including
   any unpushed changes or work in flight. Verify that its implementation and
   checks needed for handoff are complete, then invoke `review-loop` and fix findings
   until its review is clean. If the user specified a reviewer model, use it.
   Otherwise use the next model tier above the implementation model when
   available, capped below Astra and Fable. If no stronger eligible tier is
   available, use the strongest available eligible tier. Never select Astra or
   Fable for review without the user's explicit request. Pass the reviewer model,
   worktree, branch, review scope, planned tests, earlier test results and any
   unresolved failures, and any requested or standing follow-up to
   `review-loop`. Let `review-loop` carry out the follow-up after a clean review.
   When finished with a worktree created for this task, check and
   preserve uncommitted and untracked changes before removing it; never remove
   a worktree someone else is using. Report the result, commits, checks and any
   remaining issues.

# Implementation rules

Read the review preferences in the `review-code` skill when implementing and
instruct the implementation subagent to do the same. Reading these preferences
provides context and does not itself start the review workflow.

- One kind of change per PR. A refactor, a new feature and a fix are separate
  PRs. When one change needs another first, land that first, on its own, with
  its own tests, and stack the PR on it (see the `git-stack` skill).
- Small enough to review well. A reviewer reads a PR whole, and reads a small
  one better: split a large change into a stack of PRs that each do one step
  and pass the checks and CI on their own (a model, then what uses it; a
  refactor, then the feature on it).
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
  and check that it fails for the expected reason. For the delegated workflow,
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
