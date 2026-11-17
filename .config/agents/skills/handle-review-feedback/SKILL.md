---
name: handle-review-feedback
description: Review feedback on a pull request, propose responses and fixes, implement selected changes, and answer threads after pushing.
---

# Handle review feedback

An argument can be a branch name or a pull request URL. Resolve it to the PR,
repository and branch, then create a temporary worktree for that branch before
reviewing or fixing feedback. Check existing worktrees and branch ownership
first. Ask the user before using any existing worktree; do not take over a
branch in use by someone else. If the branch or PR is ambiguous, ask the user
to identify it.

When the work session is done, remove the worktree promptly, even if the PR is
still open. There should be no unfinished changes. Check for uncommitted and
untracked changes first; if any remain, ask the user what to do and preserve
them until directed. Never remove a worktree you didn't create for this skill
execution. Keep the branch and its commits so work can resume later.

1. Identify the pull request and inspect its current head, code, review
   threads, review bodies and relevant conversation comments. For each
   actionable item, show the feedback and a link, assess it against the code,
   and propose a specific fix or explain why not to change it. Call out items
   needing discussion or a decision. Ask the user which changes to make before
   implementing them.
2. Make the selected fixes on the correct branch, following the repository's
   instructions. Add meaningful tests for behavior changes and run appropriate
   checks. Commit locally in small, logical steps and report the commit SHAs.
   Keep the PR and its feedback unchanged until the user asks to push.
3. When the user asks to push the commits, review the changes as required by
   their instructions, push using the branch's prescribed workflow, and verify
   which commits reached the PR. Then respond to every piece of feedback: cite
   the pushed fix's SHA, or explain the agreed reason for not fixing it.
   Identify yourself as an AI agent in each response. Resolve each thread whose
   issue is settled; leave threads needing further discussion open and say why.
   Report any item that could not be answered or resolved.

Follow the user's instructions on shared history, worktrees, permissions and
Git stack. Do not invent a reason to decline a suggestion or claim a fix was
pushed without verification. If the user has not chosen a disposition for an
item, ask or leave it open for discussion rather than deciding for them.
