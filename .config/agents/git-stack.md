# Stacked PRs with git stack
Stack dependent PRs with [git stack](https://github.com/benekastah/git-stack).
Use the `git-stack` skill and its specialized skills when working with stacks.
Use `git recommit` only at my request, following the `git-recommit` skill.

These personal PR rules take precedence over conflicting approval guidance in
the git-stack skills. Keep their PR protections enabled and respect all other
requirements, including queue and shared-history protections.

- Before rebasing, syncing or pushing, run `git stack info`. For tracked
  branches use `git stack restack` or `sync` to rebase, `git stack push` to
  push, and `git stack pull` or `sync` instead of `git pull` (including
  `--rebase`). Add `--latest` when moving to the latest root. Never substitute
  plain `git rebase` or `git push`; if git stack can't do it, stop and explain.
  After resolving conflicts from a git stack rebase, `git rebase --continue`
  is allowed. If a branch isn't tracked, offer `git stack track main`.
- Before `git recommit` on a tracked branch, check `git stack info` and
  `git stack ownership show`; follow ownership and shared-history rules. After
  `git recommit write`, run `git stack restack` without re-tracking, so recorded
  bases preserve each branch's commits. On conflict, resolve, continue and rerun
  the restack.
- Get my permission before rearranging a stack and separately before pushing or
  syncing it unless my permission covers publication. Before moving a ready,
  conflict-free PR off `main`, warn me it would delay merging; never move a
  queued PR off `main`.
- For a stack without a PR, commit requested changes and run `git stack push
  --prs`. Push draft PR changes freely unless I say otherwise. For a PR open
  for review, offer to push and wait for my go-ahead, except when it is approved
  but has merge conflicts or failing CI. Verify current approval, conflicts and
  CI first; pending checks alone don't count. Check each affected PR before a
  stack push. This exception doesn't authorize rearranging, publishing a
  rearrangement, rewriting shared history or other separately restricted actions.
- After `git stack push --prs` or `git stack prs`, write descriptions and set
  labels for every PR opened.
