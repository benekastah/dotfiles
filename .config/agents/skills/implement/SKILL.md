---
name: implement
description: Implement a requested change, repeatedly review and fix it until the review is clean, then carry out any requested follow-up.
---

# Implement and review

1. Identify the requested change, its current state, applicable instructions and
   any follow-up the user requested. If the implementation is already complete,
   review it as it stands; otherwise implement it and run appropriate checks.
2. Review the implementation in context against the applicable review criteria.
   Use a fresh independent reviewer with no implementation context when agent
   delegation is available. Have it review the actual changes and relevant
   surrounding code, verify findings, and report their impact and fixes without
   making changes. If delegation is unavailable, review the changes yourself and
   disclose that limitation.
3. Fix the review findings that should be fixed, with appropriate checks. If
   unsure whether a finding should be fixed, show it to the user, ask, and wait
   for their direction before deciding it. Don't dismiss a finding merely to
   finish the loop.
4. Review the fixes independently again, including their consequences. Repeat
   the fix and review cycle until a review finds no issues that should be fixed.
   If a finding remains unresolved, report it and do not claim a clean review.
5. Once the review is clean, carry out any follow-up the user requested, such
   as opening a PR or merging to local main. Follow applicable instructions and
   authorization requirements for that action. If no follow-up was requested,
   report the result without inventing one.
