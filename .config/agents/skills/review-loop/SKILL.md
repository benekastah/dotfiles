---
name: review-loop
description: Review an existing change, fix findings and repeat until the review is clean, then carry out any requested follow-up.
---

# Review and fix

1. Identify the change to review, planned tests, earlier test results,
   applicable instructions, any per-finding instructions, and any follow-up
   the user requested or calling workflow supplies. Review using the current
   agent and model unless the user requests a reviewer subagent. For a requested
   subagent, follow the `review` skill's model-selection instructions and pass
   the selected model to each review. Read
   the implementation rules in `implement` as context for the review and any
   fixes; for Java changes, also read its `references/java.md`.
2. Review the change using `review`. If the user requested a reviewer subagent,
   use a fresh independent reviewer, not a fork of the current session. Give it the intended behavior, worktree,
   branch, review scope and applicable review instructions. Do not pass the
   conversation, implementation history, prior findings or other session context.
   Have it verify findings and report their impact and
   fixes without making changes. Instruct it to use `review` and the
   applicable instructions, including never skipping a git hook without the
   user’s explicit permission. If the requested subagent is unavailable, tell
   the user and continue independent work without silently substituting yourself.
3. For each review round, carry out any supplied per-finding instructions at
   the appropriate point: record or publish the findings together when required,
   then report each finding's disposition after fixing it or deciding not to.
   Follow applicable authorization and attribution rules; do not take external
   actions unless the user or invoked workflow authorizes them. Do not give
   earlier findings to the next independent reviewer.
   Treat unexpected unresolved failures from earlier checks as findings; an
   expected test-first failure is verification, not a finding. Fix the findings
   that should be fixed. Prefer deferring the final test run
   until the review is clean; run focused checks earlier when needed to diagnose
   or verify a fix. If unsure
   whether a finding should be fixed, show it to the user, ask, and wait for
   their direction before deciding it. Don't dismiss a finding to finish the
   loop.
4. Review the fixes again as in step 2, using a fresh reviewer each round if
   the user requested a subagent,
   including their consequences. Repeat
   the fix and review cycle until a review finds no issues that should be
   fixed. If a finding remains unresolved, report it and do not claim a clean
   review.
5. Once the review is clean, run the appropriate tests for the final changes,
   respecting applicable instructions on test scope and duration. If they pass,
   no further review iteration is needed. If a test run fails, return to the
   review loop with the test results as findings: investigate the failure,
   fix what needs fixing, review any changes, and run the relevant tests again
   after the review is clean. If a verified pre-existing or external failure
   has no in-scope fix, report it and stop retrying; honor any applicable gate.
   Report any tests that could not be run and do not claim they passed.
6. Once the review is clean and checks required before the action have passed,
   carry out any follow-up the user requested or standing instructions require,
   such as opening a PR or merging to local main. Tests deferred to CI may run
   after opening or updating a PR. If monitored CI fails during a requested
   follow-up, treat its results as findings and return to the loop. For a
   verified pre-existing or external CI failure with no in-scope fix, report it
   and stop retrying; a failing required gate still blocks its action. Before
   merging, satisfy any applicable CI gate on the updated revision. Follow applicable
   instructions and authorization requirements. If no follow-up applies,
   report the result without inventing one.
