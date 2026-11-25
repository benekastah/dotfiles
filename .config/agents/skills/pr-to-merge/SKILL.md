---
name: pr-to-merge
description: Take a change through draft PR creation, review, fixes and merge when authorized, or review the whole codebase after merges or on request.
---

# From PR to merge

1. Branch in a worktree (stacked if it builds on unmerged work), and commit.
2. Open a draft PR (`git stack push --prs`, or `gh pr create --draft`). Follow
   the repository's template and the user's attribution rule.
3. Invoke `review-loop` for the PR's changes against its base, with these
   per-finding instructions:
   - For each review round, post one GitHub review of type COMMENT, never
     approving or requesting changes, with findings numbered and inline on the
     relevant lines where possible. Use the head SHA on GitHub as the review's
     `commit_id`, and keep review JSON in a temporary directory, not the repo.
   - Answer every finding: fix and push it, then cite the pushed commit's short
     hash, or explain why it was not fixed. Reply to inline findings in their
     threads and body findings in one PR comment. Follow the user's attribution
     rule for reviews and responses, and ensure every finding is answered.
4. Merge only when reviews are answered, required CI is green, and the user has
   explicitly authorized the merge. Wait for human review approval.
   An exception requires both that the user has permission to merge without
   approval and that they explicitly request doing so; respect repository and
   branch protections. Merge in stack order, as the repo merges (squashed unless
   it says otherwise). For a tracked stack, check its state and restack locally
   if needed, following the `git-stack-restack` skill and the user's ownership
   and rearrangement rules. Leave syncing and publishing the stack to the user.

After a run of merges, or when asked, review the whole code at one commit of
`main`, covering modules, tests, tooling and CI, docs against code, and
cross-cutting concerns. Use subagents only if the user requests them; give each
requested reviewer one part. Record findings not yet fixed in the repo's issues
file, then fix them in PRs as above.
