---
name: review-loop
description: Review an existing change, fix findings and repeat until the review is clean, then carry out any requested follow-up.
---

# Review and fix

1. Identify the change to review, planned tests, earlier test results,
   applicable instructions, any per-finding instructions, and any follow-up
   the user requested or calling workflow supplies. Establish the scope and
   baseline. Read the `implement` rules as context for fixes; for Java, also
   read its `references/java.md`.
2. Review the change using `review`, following its instructions for scope,
   model selection and any requested subagent. Supply the worktree, branch and
   review scope. The review should report findings without making changes; the
   loop handles fixes and the final follow-up.
3. For each review round, carry out any supplied per-finding instructions at
   the appropriate point: record or publish the findings together when required,
   then report each finding's disposition after fixing it or deciding not to.
   Follow applicable authorization and attribution rules; do not take external
   actions unless the user or invoked workflow authorizes them.
   Treat unexpected unresolved failures from earlier checks as findings; an
   expected test-first failure is verification, not a finding. Apply `review`'s
   scope rules to findings and fix those that should be fixed. Don't expand the
   scope for incidental cleanup. Prefer deferring the final test run
   until the review is clean; run focused checks earlier when needed to diagnose
   or verify a fix. If unsure
   whether a finding should be fixed, show it to the user, ask, and wait for
   their direction before deciding it. Don't dismiss a finding to finish the
   loop.
4. Review the fixes again as in step 2, including their consequences. If the
   user requested a reviewer subagent, use a fresh one each round. Repeat
   the fix and review cycle until a review finds no in-scope issues that should
   be fixed. If an in-scope finding remains unresolved, report it
   and do not claim a clean review.
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
