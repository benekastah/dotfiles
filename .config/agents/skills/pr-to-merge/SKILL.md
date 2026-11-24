---
name: pr-to-merge
description: Take a change through draft PR creation, independent review, fixes and merge when authorized, or review the whole codebase after merges or on request.
---

# From PR to merge
1. Branch in a worktree (stacked if it builds on unmerged work), and commit.
2. Open a draft PR (`git stack push --prs`, or `gh pr create --draft`), saying
   in its first line that an AI agent wrote it.
3. Review it with a fresh agent: a new subagent with no context but the PR, not
   a fork of the session that wrote it, so it judges what the code says rather
   than what was meant. It reads the diff against the PR's base, its commit
   messages and the repo's AGENTS.md, and changes nothing. It looks for what
   the `review-code` skill lists, most important first, and checks each finding
   against the code before reporting it, with a severity (bug, should-fix,
   minor), a failure scenario and a fix. It posts one GitHub review of type
   COMMENT, never approving or requesting changes, saying in its first line
   that an AI agent wrote it, with its findings numbered, each inline on its
   line where it has one:

   ```sh
   gh pr view N --json headRefOid -q .headRefOid   # the head GitHub has, not a local one
   gh api repos/{owner}/{repo}/pulls/N/reviews --method POST --input "$TMP/review.json"
   # {"commit_id": "<that sha>", "event": "COMMENT", "body": "...",
   #  "comments": [{"path": "src/...", "line": 42, "side": "RIGHT", "body": "1. bug: ..."}]}
   ```

   Keep the JSON in a temporary directory, never the repo, where a commit could
   pick it up.
4. Fix, then answer every finding. The PR's author decides what to fix, fixes
   it and pushes, then answers each finding, none skipped (inline ones in their
   thread, the body's in one PR comment): fixed, with the commit's short hash,
   or why not (wrong, out of scope, or not worth its cost).
5. Review the fixes the same way, with another fresh agent, on what changed
   since the reviewed head (`<reviewed sha>..HEAD`), unless all they change is
   wording. Repeat 4 and 5 until a review finds no bugs or should-fixes.
6. Merge when it's ready: reviews answered, CI green, and the user's go-ahead.
   Merge in stack order, as the repo merges (squashed, unless it says
   otherwise), then run `git stack sync`.

After a run of merges, or when asked, review the whole code the same way:
several fresh agents at once, each given one part (a module, the tests, the
tooling and CI, the docs against the code, what cuts across) at one commit of
`main`, each reporting its findings to the agent that started them, which
records what isn't fixed yet in the repo's issues file; then fix them in PRs as
above.
