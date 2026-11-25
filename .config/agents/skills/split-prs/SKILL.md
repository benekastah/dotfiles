---
name: split-prs
description: Plan and split changes into reviewable, independently deployable pull requests or stacks.
---

# Splitting PRs
A common task is splitting a large PR into smaller ones that are easier to review.
When building the split with git stack, also follow the `git-stack-split` skill.
- Land new implementation with its first usage, rather than adding unused
  foundation code in an earlier PR. For example, put a new model and the first
  feature that uses it in the same PR, while keeping that PR safe to deploy.
- Map dependencies before choosing the PR structure. When changes can be
  reviewed, merged and deployed independently, put them on separate branches
  or stacks from their common base so they can proceed in parallel. This can
  shorten the time to deploy the feature.
- Group related parallel stacks with `git stack group add <name> <branch>...`.
  Check group membership and the scope of an operation before running it:
  commands targeting a group can affect all its stacks.
- Parallelize PRs where possible, as it aids development speed when branches
  don't depend on each other. Only parallelize PRs when each is complete and
  safe to merge and deploy on its own, in any order, including while the other
  changes are absent or old and new versions are running together. Check the
  combinations for behavior, interfaces, data and configuration compatibility.
  Stack dependent changes with git stack in the order they need to merge; each
  step must be safe to merge and deploy on its own.
- A PR over about 400 lines is hard to review. Smaller is better, to a point:
  too many tiny PRs make a change slow to deploy. Sometimes a very large PR
  can't be avoided, and that's OK.
- Split as evenly as you can, keeping each a reasonable size.
