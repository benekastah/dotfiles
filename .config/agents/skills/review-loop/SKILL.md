---
name: review-loop
description: Review an existing change, fix findings and repeat until the review is clean, then carry out any requested follow-up.
---

# Review and fix

1. Identify the change to review, planned tests, earlier test results, applicable instructions and any follow-up the
   user requested. If the reviewer model hasn't been specified, ask the user
   which model to use and wait for their answer. Offer a list of models
   available to the current agent, recommending one suited to the review's
   complexity. Pass the selected model to `review-code` for each review. Read
   the implementation rules in `implement` as context for the review and any
   fixes; for Java changes, also read its `references/java.md`.
2. Use a fresh independent reviewer with no implementation context when agent
   delegation is available. Give it the worktree, branch, and review scope.
   Have it verify findings and report their impact and
   fixes without making changes. Instruct it to use `review-code` and the
   applicable instructions, including never skipping a git hook without the
   user’s explicit permission. If delegation is unavailable, review the
   change yourself and disclose that limitation.
3. Treat unexpected unresolved failures from earlier checks as findings; an
   expected test-first failure is verification, not a finding. Fix the findings
   that should be fixed. Prefer deferring the final test run
   until the review is clean; run focused checks earlier when needed to diagnose
   or verify a fix. If unsure
   whether a finding should be fixed, show it to the user, ask, and wait for
   their direction before deciding it. Don't dismiss a finding to finish the
   loop.
4. Review the fixes again with a fresh independent reviewer as in step 2,
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
