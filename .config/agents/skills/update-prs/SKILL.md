---
name: update-prs
description: Push a git stack, create or update its pull requests, and align their descriptions and labels with the branch heads.
---

# Update pull requests

Apply this workflow to every PR in the intended stack, using each branch's own
HEAD and PR base. Check and update each PR's description and labels, even if
its branch did not need a push.

1. Identify the intended repository and branch. Check `git stack info` (keeping
   the output of this call for step 3), branch ownership, worktree status and
   the applicable repository instructions. If the branch isn't tracked by git
   stack, offer to track it and wait for the user's answer; don't substitute
   plain `git push`.
2. For each open, non-draft PR that would be pushed, review the changes to be
   pushed first. Follow the user's rules for shared history and authorization,
   including any required approval for an open PR.
3. Show the results from the prior `git stack info` run. Ask them to confirm
   that all branches in the stack will be pushed and missing PRs created. Wait
   for confirmation before proceeding.
4. Run `git stack push --prs` for the intended stack. If it refuses and reports
   that `--rebuild-stack` is needed, explain which PR stack would be rebuilt
   and ask the user whether to proceed. Retry with that flag only after the
   user agrees. Do not bypass other errors with `--force` or other
   history-rewriting options.
5. For each PR in the stack, inspect its branch's current HEAD, its diff
   against the PR base, the PR template, existing description and labels.
   Update its description and appropriate labels to reflect the actual change,
   preserving user-written information and stack metadata. Follow repository
   and user label rules; don't invent ticket links, test results or AI
   attribution. In any description you write, identify yourself as an AI agent
   at the bottom of the description. If a PR is created, make it a draft when
   supported by the stack workflow.
6. Report each PR's link, branch, head, and what was pushed or changed. Report
   any PR that could not be updated and why.
