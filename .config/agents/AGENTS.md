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
Bad:
- cd /some/directory ; do-something
- cd /some/directory ; git log

Note: no need to use `git -C` or `make -C` if you are already in the correct
directory. In the case of git, you can be in a subdirectory as well.

When adding a software dependency, don't rely on your training or memory for
the correct version. Instead, use a web search to find the latest version
and default to that.

Don't be too agreeable. Things like "Great idea!" should be reserved for actual
great ideas, not just run of the mill corrections. It's fine to push back
(often good even!), but the user has the final say.

Before committing, review the code to be committed.

When adding a comment or post as my user (e.g. adding a github comment, PR
description, etc.), lead with who you are (an AI agent, and which one, e.g.
Claude). That way people understand that I didn't write that comment directly,
you did.

# Code review
When reviewing code (either a PR or before a PR is made), I care about the
following:
- Correctness
- Readability
- Lack of surprises
- Missing tests
- Removing low-value tests
- Missing or incorrect documentation
- Missing or incorrect comments
- Dead code should be removed
- Security is important. Use secure libraries, and don't write poor versions
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
- One kind of change per PR. A refactor, a new feature and a fix are separate PRs. When one
  change needs another first, land that first, on its own, with its own tests, and stack the
  PR on it (see "Stacked PRs with git stack").
- Small enough to review well. A reviewer reads a PR whole, and reads a small one better:
  split a large change into a stack of PRs that each do one step and pass the checks and CI
  on their own (a model, then what uses it; a refactor, then the feature on it).
- Keep the docs up to date as you code, in the same commit as the change, not in a docs pass
  afterwards: the README for behavior, the repo's AGENTS.md for the shape of the code and its
  rules, and the docstrings and comments on the code you touch. Before committing, search the
  docs for the names you renamed, moved or removed.
- Ask before adding a runtime dependency; prefer the standard library.
- Work test-first: write the tests for a change (or a bug) first, run them and see them fail
  for the reason you expect, then make the change and see them pass. If the code has to be
  reshaped first for the tests to run (e.g. to inject what they replace), do only that before
  seeing them fail, so the failure still shows the old behavior.
- Every change to behavior comes with tests, in the same commit, and changes the tests that
  cover the old behavior. Make sure each would fail without the change.
- Commit in small, logical steps whose messages say why, not just what. The checks must pass
  on a PR's last commit.

# Working on several things at once
Each line of work (a feature, a stack of PRs, an experiment) gets its own git worktree, so
several agents or people can work at once without switching branches under each other:

```sh
git worktree add ../<repo>-<topic> -b <branch> origin/main
git worktree remove ../<repo>-<topic>    # when it's merged
```

- Leave the main checkout on `main`. An editable install, an editor or another session may be
  running its code; switching its branch changes their code too, mid-run.
- One owner per branch. Don't commit or push to a branch another agent is working on. Hand it
  over explicitly, saying what's unpushed and what's in flight.
- Don't rewrite pushed history someone else may have built on. Add commits, or start a new
  branch and PR, rather than force-pushing a shared branch.

# Stacked PRs with git stack
When a change needs another that isn't merged yet, stack them with
[git stack](https://github.com/benekastah/git-stack), which keeps each branch rebased on the
one below it and each PR pointed at its base:

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

# From PR to merge
1. Branch in a worktree (stacked if it builds on unmerged work), and commit.
2. Open a draft PR (`git stack push --prs`, or `gh pr create --draft`), saying in its first
   line that an AI agent wrote it.
3. Review it with a fresh agent: a new subagent with no context but the PR, not a fork of the
   session that wrote it, so it judges what the code says rather than what was meant. It reads
   the diff against the PR's base, its commit messages and the repo's AGENTS.md, and changes
   nothing. It looks for what "Code review" above lists, most important first, and checks each
   finding against the code before reporting it, with a severity (bug, should-fix, minor), a
   failure scenario and a fix. It posts one GitHub review of type COMMENT, never approving or
   requesting changes, saying in its first line that an AI agent wrote it, with its findings
   numbered, each inline on its line where it has one:

   ```sh
   gh pr view N --json headRefOid -q .headRefOid   # the head GitHub has, not a local one
   gh api repos/{owner}/{repo}/pulls/N/reviews --method POST --input "$TMP/review.json"
   # {"commit_id": "<that sha>", "event": "COMMENT", "body": "...",
   #  "comments": [{"path": "src/...", "line": 42, "side": "RIGHT", "body": "1. bug: ..."}]}
   ```

   Keep the JSON in a temporary directory, never the repo, where a commit could pick it up.
4. Fix, then answer every finding. The PR's author decides what to fix, fixes it and pushes,
   then answers each finding, none skipped (inline ones in their thread, the body's in one PR
   comment): fixed, with the commit's short hash, or why not (wrong, out of scope, or not
   worth its cost).
5. Review the fixes the same way, with another fresh agent, on what changed since the
   reviewed head (`<reviewed sha>..HEAD`), unless all they change is wording. Repeat 4 and 5
   until a review finds no bugs or should-fixes.
6. Merge when it's ready: reviews answered, CI green, and the user's go-ahead. Merge in stack
   order, as the repo merges (squashed, unless it says otherwise), then run `git stack sync`.

After a run of merges, or when asked, review the whole code the same way: several fresh agents
at once, each given one part (a module, the tests, the tooling and CI, the docs against the
code, what cuts across) at one commit of `main`, posting their findings on one issue; then fix
them in PRs as above.
