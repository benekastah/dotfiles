---
name: review-loop
description: Review an existing change, fix findings and repeat until the review is clean, then carry out any requested follow-up.
---

# Review and fix

1. Identify the change to review, applicable instructions and any follow-up the
   user requested. Review the actual change and relevant surrounding code against
   the applicable review criteria.
2. Use a fresh independent reviewer with no implementation context when agent
   delegation is available. Have it verify findings and report their impact and
   fixes without making changes. If delegation is unavailable, review the change
   yourself and disclose that limitation.
3. Fix the findings that should be fixed, with appropriate checks. If unsure
   whether a finding should be fixed, show it to the user, ask, and wait for
   their direction before deciding it. Don't dismiss a finding to finish the loop.
4. Review the fixes independently again, including their consequences. Repeat
   the fix and review cycle until a review finds no issues that should be fixed.
   If a finding remains unresolved, report it and do not claim a clean review.
5. Once the review is clean, carry out any follow-up the user requested, such
   as opening a PR or merging to local main. Follow applicable instructions and
   authorization requirements for that action. If no follow-up was requested,
   report the result without inventing one.
