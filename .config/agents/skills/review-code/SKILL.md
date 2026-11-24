---
name: review-code
description: Review code changes or pull requests using the user's preferences, then carry out a requested follow-up or report the findings.
---

# Review code

Usually delegate the review to a fresh reviewer subagent. If the reviewer model
has not been specified by the user or calling workflow, ask the user which
model to use and wait for their answer. Offer a list of models available to the
current agent, recommending one suited to the review's complexity. Use the
selected model for the reviewer; if delegation is unavailable, explain the
limitation before reviewing yourself. When you are the designated reviewer,
conduct the review yourself rather than delegating it again.

Review the requested change, then carry out the follow-up specified by the user
or the calling workflow, subject to applicable authorization requirements. If
none was specified, report what is good and bad about the change, focusing on
issues to fix. Verify findings and explain their impact, location and a
possible fix; report significant strengths when supported by the code. If there
are no findings, say so and mention any material review or validation limits.

## Review preferences

Read the implementation rules in the `implement` skill as review context. For
Java changes, also read its `references/java.md`. Do not start its
implementation or delegation workflow just because you are reviewing code.

Review the change and its wider context for:

- Correctness. Obviously correct is much better than just correct.
- Simplicity. Prefer the simplest implementation that meets the requirements.
  Avoid repeated code when a shared abstraction improves clarity; trivial
  repetition is fine, and the rule of three is a useful guide.
- Readability
- Lack of surprises. Anything surprising that's necessary should have a comment
  and a test. Only necessary changes should be accepted.
- Missing tests. Coverage matters, and we aim to raise it; new features should
  be fully covered.
- Removing low-value tests. Estimate each test's value: could it catch a real
  bug, or prevent a regression? Would it even fail if the code were wrong in a
  meaningful way? Tests should be no bigger than they need to be, simple and
  readable; where one must be complex, consider another approach, or at least
  comment it.
- Missing or incorrect documentation
- Missing or incorrect comments
- Remove unused code.
- Security is important. Use secure libraries, and don't write your own version
  of what the right library can do.
- No comments that are based solely on a prior state of the code or rejected
  ideas from our conversation.
    - If we removed Foo, don't comment "we don't need Foo"
    - If we thought about adding Foo, but the user rejected it, no need to
      comment on it in the code.
- Tests added shouldn't simply replicate what we do, they represent the correct
  state of things. No need to test a bad behavior, unless the user explicitly
  authorizes it.
- Review in a wider context than the changeset. What are the consequences? Does
  the change cause anything outside of the changeset to be inconsistent?
- Prefer fully qualified imports to relative imports
- In java/kotlin, prefer imports to fully qualified names
- Size. Large PRs should be avoided: recommend splitting a large change into
  several PRs when there's a viable way to (see the `split-prs` skill).
- Risk. Call out notable risks, and say when a PR's risk label doesn't match
  your estimate. Use a feature flag where possible, especially for a risky
  change.
- Importance. Does the change move the needle, or contribute to an important
  goal? Challenge unimportant changes.
- Cost. Call out changes that may add cost, or unnecessary cost.
- Terseness. Only necessary changes; comments and docs should be terse without
  giving up readability or correctness.
- When running SQL queries, do the filtering in SQL instead of pulling down all
  records and filtering in the program.
- When running SQL queries, it's useful to do as few queries as reasonably
  possible. This should be done in a way that doesn't violate the architecture
  (for example, if we have multiple repositories where queries happen, there
  should be a good reason before we introduce a query that spans multiple
  tables represented by those repositories).
