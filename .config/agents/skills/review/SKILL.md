---
name: review
description: Review code, agent instructions, skills or other changes using the user's preferences, then carry out a requested follow-up or report the findings.
---

# Review changes

Review using the current agent and model by default. Use a subagent only when
the user requests one. For a requested subagent review, use a fresh reviewer,
not a fork of the current session. Give it the intended behavior, review target
and scope, and applicable review instructions, including never skipping a git
hook without the user's explicit permission; do not pass conversation history,
implementation details, prior findings or other session context. Let it inspect
the change and its wider context independently. Honor a specified model; if no
model is specified, ask the user which to use, with suitable choices and a
recommendation. If the requested subagent is unavailable, tell the user and
continue independent work; do not silently substitute a self-review. When you
are the designated reviewer, review directly rather than delegating again.

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

Review the change and its wider context for the applicable preferences below.
Assess findings against the changeset and its baseline. A preexisting issue is
in scope when the change directly affects or worsens it, or it is otherwise
relevant to the behavior under review. Report unrelated preexisting issues
separately; do not fail the review or require fixes for them. If relevance is
unclear, explain the uncertainty and ask the user.
For agent instructions and skills, also check that instructions are clear,
actionable, consistent with related guidance and suited to their intended use.
Apply code-specific guidance only when relevant.

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
