---
name: move-forward
description: Review work in flight, identify blockers and next actions across pull requests and tickets, and carry out an authorized sweep or focused slice.
disable-model-invocation: true
---

# Move forward

Help move the user's work forward: inspect work in flight, identify blockers and next actions, and perform the requested sweep or focused slice. Use the user's current instructions and configured tools; do not assume a particular organization, repository, team, or tracker.

## Local profile

Before proceeding, read `~/.local/agents/skills/move-forward-local/profile.md` if it exists. It contains the user's local workflow, organization-specific configuration, and approval rules. Resolve its relative references, including `references/dashboard.md` and `reviewer-map.md`, relative to that profile's directory. Follow it together with the user's current instructions. If it is absent, use the portable guidance below and do not invent configuration or organization-specific rules.

## Scope and workflow

Interpret the user's request as a full sweep or a focused slice, such as status, reviews, feedback, CI, sync, PRs, nudges, merge, cleanup, tickets, or next work. For a focused request, gather only the information needed for that slice. Batch independent read-only checks and decisions; continue independent work when one item is blocked.

Identify relevant repositories, branches, PRs, tickets, review requests, CI status, outstanding feedback, and user-maintained notes from available sources. Respect explicit holds, snoozes, and iced work. If their state cannot be established, report that limitation and avoid acting on possibly held work. Prefer current source data to stale notes and identify uncertainty.

Prioritize unblocking other people's reviews, then address author-side feedback, failing checks and stack state before proposing review reminders or merges. Review actual review requests, feedback, checks, and merge conditions rather than assuming an approval or a failing policy check tells the whole story. Keep work notes current when the user has configured them and the relevant update is authorized.

Use the user's Git and worktree instructions. Check stack state and ownership before changing branches; preserve uncommitted work and avoid interfering with other agents. Report changes made, actions waiting on the user, and actions waiting on others. Link directly to each PR, ticket, review thread, or build discussed.

Read-only checks do not authorize external messages, review comments, reviewer assignment, merges, or destructive cleanup. Follow the user's approval rules for each action. Before sending a reminder, verify the destination and whether an earlier reminder exists, present the exact message and destination, and wait for approval. If a needed integration is unavailable, say what could not be verified.
