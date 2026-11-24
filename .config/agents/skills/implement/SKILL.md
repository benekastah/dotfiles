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
   the user's request, decisions, target worktree and branch, applicable
   instructions and requested follow-up. Tell it never to skip a git hook
   without the user's explicit permission. It implements the change, keeps docs
   current, follows test-first and commit instructions, runs appropriate checks,
   and reports commits, checks, outstanding work and any blockers. If delegation
   is unavailable, tell the user and continue independent work; don't silently
   implement the delegated work in the main session.
4. Review the subagent's result and verify that the request and required checks
   are complete. Carry out any requested follow-up within its authorization and
   applicable instructions; use `review-loop` if the user requested that
   workflow. When finished with a worktree created for this task, check and
   preserve uncommitted and untracked changes before removing it; never remove
   a worktree someone else is using. Report the result, commits, checks and any
   remaining issues.
