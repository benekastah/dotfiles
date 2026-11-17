---
name: update-pr
description: Push a git stack, create or update its pull requests, and align their descriptions and labels with the branch heads.
---

# Update pull requests

1. Identify the intended repository and branch. Check `git stack info`, branch ownership, worktree status and the applicable repository instructions. If the branch isn't tracked by git stack, offer to track it and wait for the user's answer; don't substitute plain `git push`.
2. For each open, non-draft PR that would be pushed, review the changes to be pushed first. Follow the user's rules for shared history and authorization, including any required approval for an open PR.
3. Run `git stack push --prs` for the intended stack. If it refuses and reports that `--rebuild-stack` is needed, explain which PR stack would be rebuilt and ask the user whether to proceed. Retry with that flag only after the user agrees. Do not bypass other errors with `--force` or other history-rewriting options.
4. For each PR created or updated, inspect the current branch HEAD, its diff against the PR base, the PR template, existing description and labels. Update its description and appropriate labels to reflect the actual change, preserving user-written information and stack metadata. Follow repository and user label rules; don't invent ticket links, test results or AI attribution. Identify yourself as an AI agent in any description you write, as required by the user's instructions. If a PR is created, make it a draft when supported by the stack workflow.
5. Report each PR's link, branch, head, and what was pushed or changed. Report any PR that could not be updated and why.
