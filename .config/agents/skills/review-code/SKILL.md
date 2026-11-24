---
name: review-code
description: Review code changes or pull requests using the user’s review preferences.
---

# Review preferences

Review the change and its wider context for:
- Correctness. Obviously correct is much better than just correct.
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
- Dead code should be removed
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
- Review in a wider context than the changeset. What are the consequences?
  Does the change cause anything outside of the changeset to be inconsistent?
- Prefer fully qualified imports to relative imports
- In java/kotlin, prefer imports to fully qualified names
- Size. Large PRs should be avoided: recommend splitting a large change into
  several PRs when there's a viable way to (see "Splitting PRs").
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
  should be a good reason before we introduce a query that spans multiple tables
  represented by those repositories).
