# Global instructions for coding agents
How I work in every project, whatever its language. A repo's own AGENTS.md says
what's true of that project, and wins where the two differ. This file lives in
my dotfiles (`.config/agents/AGENTS.md`); Claude Code imports it from its
CLAUDE.md, and Codex reads it through a link.

# General guidance
Don't run `cd` or any command that changes the working directory without
wrapping it in a shell process (so that we return to our original working
directory when the command is done).

Good:
- (cd /some/directory ; do-something)
- git -C /some/directory log
- rg pattern /some/file.txt
Bad:
- cd /some/directory ; do-something
- cd /some/directory ; git log

If you do `cd` into another directory, `cd` back to the original one as soon as
you're done there.

Note: no need to use `git -C` or `make -C` if you are already in the correct
directory. In the case of git, you can be in a subdirectory as well.

When adding a software dependency, don't rely on your training or memory for
the correct version. Instead, use a web search to find the latest version
and default to that.

Don't be too agreeable. Things like "Great idea!" should be reserved for actual
great ideas, not just run of the mill corrections. It's fine to push back
(often good even!), but the user has the final say.

Before pushing to an open, non-draft PR, review the code to be pushed. Before
moving an open draft PR out of draft, review the PR.

When adding a comment or post as my user (e.g. adding a github comment, PR
description, etc.), lead with who you are (an AI agent, and which one, e.g.
Claude). That way people understand that I didn't write that comment directly,
you did.

Unless I ask you to post a comment (on a GitHub PR, a Jira ticket or anywhere
else), don't: send me a draft of what you'd post instead, since I may want to
change it. Following a workflow I asked for (e.g. "From PR to merge" below)
counts as asking. When posting review comments on a PR, post them all in one
review, each on the code it's about, rather than one review per comment or every
item in one comment attached to no code.

Never run `git reset --hard` without my explicit permission: it destroys changes
the branch may need.

# Code review
When reviewing code (either a PR or before a PR is made), I care about the
following:
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

# Process
- Every prompt ends with an implicit question to you, "Do you have any questions?"
If you have no questions, no need to reply. If you have questions, ask them
before taking action.

# Making changes
- One kind of change per PR. A refactor, a new feature and a fix are separate
  PRs. When one change needs another first, land that first, on its own, with
  its own tests, and stack the PR on it (see "Stacked PRs with git stack").
- Small enough to review well. A reviewer reads a PR whole, and reads a small
  one better: split a large change into a stack of PRs that each do one step
  and pass the checks and CI on their own (a model, then what uses it; a
  refactor, then the feature on it).
- Keep the docs up to date as you code, in the same commit as the change, not
  in a docs pass afterwards: the README for behavior, the repo's AGENTS.md for
  the shape of the code and its rules, and the docstrings and comments on the
  code you touch. Before committing, search the docs for the names you renamed,
  moved or removed.
- Never change changelog entries for prior versions. Add new entries under the
  upcoming release section.
- Ask before adding a runtime dependency; prefer the standard library.
- Work test-first: write the tests for a change (or a bug) first, run them and
  see them fail for the reason you expect, then make the change and see them
  pass. If the code has to be reshaped first for the tests to run (e.g. to
  inject what they replace), do only that before seeing them fail, so the
  failure still shows the old behavior.
- Every change to behavior comes with tests, in the same commit, and changes
  the tests that cover the old behavior. Make sure each would fail without the
  change.
- Commit the code I ask you to write, in small, logical steps whose messages
  say why, not just what, and tell me the commits you made, since I'll want to
  review them. The checks must pass on a PR's last commit.
- Running tests is good, but a long full run taxes my machine, and CI runs it
  anyway: when the tests take more than about 30 seconds, run the ones near the
  change and leave the full run to CI, unless the repo says otherwise.

# Splitting PRs
A common task is splitting a large PR into smaller ones that are easier to review.
- Avoid adding code in one PR that nothing uses until a later one: split so
  that each implementation lands with its usages.
- Stack the PRs with git stack, in the order they should merge. Each must be
  safe to merge (and deploy) on its own, one at a time.
- A PR over about 400 lines is hard to review. Smaller is better, to a point:
  too many tiny PRs make a change slow to deploy. Sometimes a very large PR
  can't be avoided, and that's OK.
- Split as evenly as you can, keeping each a reasonable size.

# Deploy safety
Deploys often happen in no guaranteed order, so at each seam between parts that
deploy separately, old and new code may run at the same time (e.g. on different
pods). When writing, reviewing or splitting PRs, check that each step is safe
that way. The repo often says how, in its code or its agent instructions.

# Working on several things at once
Each line of work (a feature, a stack of PRs, an experiment) gets its own git
worktree, so several agents or people can work at once without switching
branches under each other:

```sh
git worktree add ../<repo>-<topic> -b <branch> origin/main
git worktree remove ../<repo>-<topic>    # when done working in it
```

- Leave the main checkout on `main`. An editable install, an editor or another
  session may be running its code; switching its branch changes their code too,
  mid-run.
- One owner per branch. Don't commit or push to a branch another agent is
  working on. Hand it over explicitly, saying what's unpushed and what's in
  flight.
- Remove a worktree you created when you're done working in it, even if its PR
  is still open. Clean up promptly: a branch checked out in a worktree can make
  `git stack restack` and `git stack sync` fail. First check for uncommitted or
  untracked changes and preserve them. Don't remove a worktree someone else is
  using. Keep the branch so a worktree can be created again later.
- Don't rewrite pushed history someone else may have built on. Add commits, or
  start a new branch and PR, rather than force-pushing a shared branch.
- If we're already in the right repository, check whether I've made a stack for
  the change; if not, offer to make one from the current `main`.

# Stacked PRs with git stack
When a change needs another that isn't merged yet, stack them with [git
stack](https://github.com/benekastah/git-stack), which keeps each branch
rebased on the one below it and each PR pointed at its base:

```sh
git stack branch add-model      # a branch for PR 1, on main
# ...commit...
git stack branch use-model      # a branch for PR 2, on PR 1
# ...commit...
git stack push --prs            # push both, and open draft PRs, each into the branch it's on
git stack info                  # the stack, each branch's PR, and what needs restacking
git stack restack               # after changing a lower branch: rebase the ones above it
git stack sync                  # after a merge: drop merged PRs, rebase what's left, push
```

`git stack --help` (its man page, from its README) explains the rest.
- Before rebasing, syncing or pushing a branch, check `git stack info` to see
  whether it is tracked and understand its stack. For tracked branches, use
  `git stack restack` or `git stack sync` to rebase and `git stack push` to
  push; never start a plain `git rebase` or use `git push` as a substitute.
  Use `git stack pull` to update locally, or `git stack sync` to update and
  push, instead of `git pull` or `git pull --rebase`. Add `--latest` when the
  stack should move onto the latest root commit.
  After resolving a conflict in a rebase started by git stack, `git rebase
  --continue` is allowed. If git stack cannot perform the operation, stop and
  explain the problem rather than bypassing it with plain Git.
- If a branch isn't tracked, offer to track it (`git stack track main`).
- A stack with no PR yet: when I ask for changes, commit them and run
  `git stack push --prs`.
- A stack whose PR is a draft: push changes freely, unless I say not to.
- A stack whose PR is open for review: offer to push, and wait for my go-ahead.
- After `git stack push --prs` or `git stack prs`, write the description and
  set the labels of each PR it opened.

# Refactoring commits with git recommit
Use [git recommit](https://github.com/benekastah/git-recommit) when rebuilding
commits into smaller, logical, independently reviewable steps. Agents should
use its non-interactive CLI, not the TUI; read its documentation and subcommand
help before using it. Start a plan with `git recommit start <range>`, inspect it
with `git recommit show --json`, and use the `commit`, `assign`, `unassign`,
and `edit` subcommands to shape it. Finish with `git recommit write --validate
'<test command>'`, or discard the plan with `git recommit abort`. Use `HEAD` as
the range to split uncommitted changes. Check the range and worktree first:
tracked uncommitted changes are included, and `-u` includes untracked files too.
Preserve others' work and don't rewrite pushed history someone else may have
built on. For a tracked stack, check `git stack info` first and use git stack
to restack and push affected branches afterwards, subject to the push rules
above.

# From PR to merge
1. Branch in a worktree (stacked if it builds on unmerged work), and commit.
2. Open a draft PR (`git stack push --prs`, or `gh pr create --draft`), saying
   in its first line that an AI agent wrote it.
3. Review it with a fresh agent: a new subagent with no context but the PR, not
   a fork of the session that wrote it, so it judges what the code says rather
   than what was meant. It reads the diff against the PR's base, its commit
   messages and the repo's AGENTS.md, and changes nothing. It looks for what
   "Code review" above lists, most important first, and checks each finding
   against the code before reporting it, with a severity (bug, should-fix,
   minor), a failure scenario and a fix. It posts one GitHub review of type
   COMMENT, never approving or requesting changes, saying in its first line
   that an AI agent wrote it, with its findings numbered, each inline on its
   line where it has one:

   ```sh
   gh pr view N --json headRefOid -q .headRefOid   # the head GitHub has, not a local one
   gh api repos/{owner}/{repo}/pulls/N/reviews --method POST --input "$TMP/review.json"
   # {"commit_id": "<that sha>", "event": "COMMENT", "body": "...",
   #  "comments": [{"path": "src/...", "line": 42, "side": "RIGHT", "body": "1. bug: ..."}]}
   ```

   Keep the JSON in a temporary directory, never the repo, where a commit could
   pick it up.
4. Fix, then answer every finding. The PR's author decides what to fix, fixes
   it and pushes, then answers each finding, none skipped (inline ones in their
   thread, the body's in one PR comment): fixed, with the commit's short hash,
   or why not (wrong, out of scope, or not worth its cost).
5. Review the fixes the same way, with another fresh agent, on what changed
   since the reviewed head (`<reviewed sha>..HEAD`), unless all they change is
   wording. Repeat 4 and 5 until a review finds no bugs or should-fixes.
6. Merge when it's ready: reviews answered, CI green, and the user's go-ahead.
   Merge in stack order, as the repo merges (squashed, unless it says
   otherwise), then run `git stack sync`.

After a run of merges, or when asked, review the whole code the same way:
several fresh agents at once, each given one part (a module, the tests, the
tooling and CI, the docs against the code, what cuts across) at one commit of
`main`, posting their findings on one issue; then fix them in PRs as above.

# Java
- Put constant values in `private static final` fields of the class that uses
  them, especially a value used more than once.
- Put a large SQL query (10 lines or more) in its own file (usually in a
  `resources` package), loaded the project's usual way.
- Write good javadocs for new classes, interfaces, methods and properties, and
  for fields whose purpose isn't obvious; update the existing ones a change
  makes untrue.
- Don't use bare `assert`: use `assertThat` in tests, and throw an exception
  elsewhere.

# Choosing a model
Work on Sonnet by default, and spawn subagents on Opus for reviews, research
and tasks that need stronger reasoning. Recommend another model when the task
warrants it, and give subagents a stronger or cheaper model as fits their part:
- Haiku: formatting, boilerplate, tiny refactors, small scripts, simple tests,
  and simple research whose answer is a web search away. The cheapest, so
  prefer it when it fits.
- Sonnet: general coding, test fixes, ordinary code reviews, moderate
  debugging. A good balance of quality, speed and cost for everyday work.
- Opus: merge conflicts, more complicated coding, planning, research. Costs
  more.
- Fable: complex refactors, ambiguous requirements, multi-module design, novel
  algorithms, tough incidents, deep research. Its stronger reasoning saves
  failed attempts and rework, but it costs a lot: use it sparingly.

Beyond the model, consider reasoning effort: lowering it on a strong model can
cost less than switching to a weaker one, while keeping its knowledge and
instruction-following. Use high effort for planning, debugging and ambiguous
problems, and low or medium for mechanical edits, formatting and well-specified
tasks.

In Codex: Luna with medium effort to fetch GitHub comments, Astra with medium
effort to review how comments were addressed, and Luna with xhigh or max effort
to implement.

# Google Docs suggested edits
When asked to suggest an edit, make a native Google Docs suggestion I can
accept or reject.
- Authenticate for Google Drive with
  `gcloud auth login --enable-gdrive-access --force` when needed; use the
  existing login if it already works.
- Get an access token with `gcloud auth print-access-token`, keeping it in
  memory (an environment variable is fine) and sending it as a Bearer token to
  the Google Docs API. Never print, log or persist it, or put it in the
  session's context.
- Prefer connector tools when they offer suggestion mode. Otherwise call the
  Google Docs REST API with the gcloud token; don't assume the API can't make
  suggestions.
- Read
  `GET https://docs.googleapis.com/v1/documents/{documentId}?includeTabsContent=true&suggestionsViewMode=SUGGESTIONS_INLINE`
  to find the exact text, the tab's ID, UTF-16 indexes, existing suggestions
  and the revision ID. Look at overlapping suggestions before editing.
- Send the edit to
  `POST https://docs.googleapis.com/v1/documents/{documentId}:batchUpdate`
  with `writeControl.writeMode` set to `SUGGEST` and
  `writeControl.requiredRevisionId` set to the revision just read. For a
  deletion, use `deleteContentRange` with `range.tabId`, `range.startIndex`
  and `range.endIndex`. A batch update without suggestion mode edits the
  document directly.
- Check that `commentUpdateState` is `ALL_SAVED`, then read the changed area
  back with `SUGGESTIONS_INLINE` and check that the text has
  `suggestedDeletionIds` or `suggestedInsertionIds` as intended. If the
  write's outcome is uncertain or it partly failed, look at the document's
  current state before retrying.

# Local instructions
If `~/.config/agents/AGENTS.local.md` exists, read and follow it as well.
