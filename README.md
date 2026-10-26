# learngit

Hands-on Git and GitHub practice, from your first commit to running releases and cleaning up production incidents.
Inspired by [Learn Git Branching](https://learngitbranching.js.org/), but with **real repositories in your own
terminal**: every exercise builds a realistic (often broken) situation at a fictional online store called
*Brightcart*, you fix it with real Git commands, and a checker tells you whether you got it right.

**115 exercises · 12 modules** — branching, merging, rebase, cherry-pick, undo and recovery, stash and worktrees,
history forensics (blame, pickaxe, bisect), remotes and teamwork, the disasters every senior developer has lived
through (leaked secrets, force-push accidents, giant files, wrong authors), power tools (hooks, rerere,
submodules, signing), a lead and PM playbook (releases, hotfixes, changelogs, incidents, ownership), and a
GitHub track you do for real with the `gh` CLI (PRs, reviews, protection rules, Actions, releases, Projects).

## Quick start

```bash
git clone https://github.com/RupeshKoirala/learngit.git
cd learngit
./lg doctor        # checks git, gh and git-filter-repo
./lg list          # all exercises and your progress
./lg start 1       # builds exercise 1 in a sandbox and shows the task
```

Then work in the sandbox it prints (under `~/learngit-playground/`), and:

```bash
./lg check         # did I do it?
./lg hint          # a nudge (run again for bigger hints)
./lg graph         # draw the commit graph — keep this open in a second terminal
./lg reset         # start this exercise over
./lg solution      # the worked solution with real-world notes
./lg next          # on to the next one
```

Tip: put the folder on your PATH or add `alias lg=~/path/to/learngit/lg` so you can run `lg check` from inside
the sandbox. `lg` also figures out which exercise you're in from your current directory.

**Your real repositories are never touched.** Every exercise lives in its own throwaway folder under
`~/learngit-playground/` (change it with `LEARNGIT_HOME=...`). "Remotes" are local bare repositories, so you can
force-push, rewrite and break things freely. Only module 12 talks to GitHub, using a private `learngit-lab`
repo it helps you create.

## Requirements

- macOS or Linux (Windows: use WSL or Git Bash), bash 3.2+ (the Mac default is fine)
- Git 2.38+ recommended (`brew install git`); a few exercises mention fallbacks for older versions
- For 072–073: `brew install git-filter-repo`
- For module 12: `brew install gh && gh auth login`. On a free GitHub plan, branch protection (106) needs the
  lab repo to be public — the exercise explains.

## Read alongside

| Doc | What it's for |
|---|---|
| [docs/mental-model.md](docs/mental-model.md) | 15 minutes that make everything else click: commits, branches as pointers, HEAD, the three areas, remotes |
| [docs/practice-plan.md](docs/practice-plan.md) | A session-by-session plan |
| [docs/cheatsheet.md](docs/cheatsheet.md) | The commands and config you'll use daily |
| [docs/recovery-playbook.md](docs/recovery-playbook.md) | "I did X, how do I undo it?" |
| [docs/team-workflows.md](docs/team-workflows.md) | Branching strategies, PR etiquette, merge methods, releases, incidents — for leads and PMs |

## Exercises

### 01 · Foundations

| # | Exercise | Level |
|---|---|---|
| 001 | Your first repository: init, identity, first commits | ★ |
| 002 | The three areas: split a pile of changes into logical commits | ★ |
| 003 | Stage part of a file with git add -p | ★★ |
| 004 | Fix your last commit: typo and forgotten file (amend) | ★ |
| 005 | Undo local changes: restore, unstage and clean safely | ★★ |
| 006 | .gitignore done right: untrack, negate, debug | ★★ |
| 007 | Read diffs like a reviewer | ★★ |
| 008 | Search the log like a detective | ★★ |
| 009 | Move and rename files without losing history | ★★ |
| 010 | Write commit messages your team will love | ★ |

### 02 · Branching & merging

| # | Exercise | Level |
|---|---|---|
| 011 | Branches are just pointers: create, switch, list, rename | ★ |
| 012 | Fast-forward vs merge commit (and --ff-only) | ★ |
| 013 | Your first merge conflict: keep both intents | ★ |
| 014 | Multi-file conflicts, modify/delete, abort and redo with diff3 | ★★ |
| 015 | Conflicts in generated files: lockfiles | ★★ |
| 016 | Oops, I committed to main: move the work to a feature branch | ★★ |
| 017 | Committed on the wrong feature branch: move 2 commits | ★★ |
| 018 | Detached HEAD: rescue the commits you left behind | ★★ |
| 019 | Branch hygiene: delete merged branches, keep the WIP | ★★ |

### 03 · Rebase

| # | Exercise | Level |
|---|---|---|
| 020 | Rebase your feature onto the updated main | ★★ |
| 021 | Rebase with conflicts: --continue, --skip, --abort | ★★ |
| 022 | Squash your messy WIP commits before review | ★★ |
| 023 | Reword, reorder and drop commits before review | ★★ |
| 024 | Split one commit into two | ★★★ |
| 025 | Fix review feedback with fixup! commits and --autosquash | ★★ |
| 026 | rebase --onto: move only your commits after a squash-merge | ★★★ |
| 027 | Rebase a stack of dependent branches with --update-refs | ★★★ |
| 028 | Make every commit pass the tests with rebase -x | ★★★ |
| 029 | Undo a bad rebase with the reflog | ★★ |
| 030 | Rebase a branch that contains merges (--rebase-merges) | ★★★ |

### 04 · Cherry-pick & backports

| # | Exercise | Level |
|---|---|---|
| 031 | Cherry-pick one bug fix from a teammate's unfinished branch | ★ |
| 032 | Cherry-pick a range of commits, then combine picks with -n | ★★ |
| 033 | Cherry-pick with a conflict: the code moved on main | ★★ |
| 034 | Backport a security hotfix to two release lines with -x | ★★★ |
| 035 | Cherry-pick a merge commit to bring a whole feature to a release | ★★★ |
| 036 | Which releases contain this fix? Find and close backport gaps | ★★★ |

### 05 · Undo & recovery

| # | Exercise | Level |
|---|---|---|
| 037 | reset --soft / --mixed / --hard: squash, unstage, beware | ★ |
| 038 | Revert a bad commit that's already on shared main | ★★ |
| 039 | Revert a merge commit that broke main (-m 1) | ★★ |
| 040 | Revert the revert: re-land a fixed, reverted feature | ★★★ |
| 041 | Recover a deleted, unmerged branch with the reflog | ★★ |
| 042 | Recover commits after an accidental reset --hard | ★★ |
| 043 | Recover a cleared stash from dangling commits (git fsck) | ★★★ |
| 044 | Bring back a file deleted several commits ago | ★★ |
| 045 | Undo a commit --amend that swallowed the wrong changes | ★★ |
| 046 | Restore one file to its version from an older tag | ★ |
| 047 | Undo an unpushed merge; abort a half-resolved one | ★★★ |

### 06 · Stash & worktrees

| # | Exercise | Level |
|---|---|---|
| 048 | Stash basics: untracked files, named stashes, apply and drop | ★ |
| 049 | Stash only some files, and survive a stash pop conflict | ★★ |
| 050 | Urgent hotfix mid-feature: fix production in a second worktree | ★★ |
| 051 | The stash no longer applies: recover it with git stash branch | ★★ |

### 07 · Investigating history

| # | Exercise | Level |
|---|---|---|
| 052 | git blame like a detective: see through moves, re-indents and reformats | ★★★ |
| 053 | Pickaxe search: find who removed a function and who changed a regex | ★★ |
| 054 | git bisect by hand: find the commit that broke the checkout page | ★★ |
| 055 | git bisect run: let a script find the bug in 200 commits | ★★★ |
| 056 | Ranges that confuse everyone: .., ..., --first-parent, ^exclusions | ★★ |
| 057 | git range-diff: what changed when the PR was force-pushed? | ★★★ |
| 058 | One function's whole story: log -L, show --stat, grep the past | ★★ |
| 059 | Release stats for your PM: shortlog, --since, hot files, .mailmap | ★★ |

### 08 · Remotes & teamwork

| # | Exercise | Level |
|---|---|---|
| 060 | Clone, inspect origin, and update without surprises | ★ |
| 061 | Push rejected: a teammate pushed first | ★★ |
| 062 | Upstream tracking: push -u, ahead/behind, set and unset | ★★ |
| 063 | Force-push safely with --force-with-lease | ★★★ |
| 064 | A teammate force-pushed over your commits: recover them | ★★★ |
| 065 | Fork workflow: sync with upstream and update your PR | ★★ |
| 066 | Remote housekeeping: prune, delete, rename master to main | ★★ |
| 067 | "You have divergent branches": merge, rebase or ff-only? | ★★ |
| 068 | Tags on a remote: push them carefully, fix a wrong one | ★★ |
| 069 | Review a teammate's pull request locally | ★★ |
| 070 | Multiple remotes: backup mirror, set-url, rename, remove | ★★ |
| 071 | Shallow and partial clones: fast CI, limited history | ★★★ |

### 09 · Disasters & bad commits

| # | Exercise | Level |
|---|---|---|
| 072 | Purge a leaked .env secret from all history | ★★★ |
| 073 | Evict a 20 MB video from history to slim every clone | ★★★ |
| 074 | Fix commits made with your personal email | ★★ |
| 075 | Clean up "Merge branch 'main' of origin" noise | ★★ |
| 076 | Broke main, team pulled: revert, then fix forward | ★★ |
| 077 | Case-only renames that confuse macOS and Windows | ★★ |
| 078 | File-mode noise: undo a chmod 755 on everything | ★★ |
| 079 | Split a 1,500-line commit into three stacked PRs | ★★★ |
| 080 | Get node_modules/ and dist/ out of your branch's history | ★★★ |
| 081 | Merge your edits into a file a teammate moved | ★★★ |

### 10 · Power tools

| # | Exercise | Level |
|---|---|---|
| 082 | Shared Git hooks: block secrets, enforce Conventional Commits | ★★★ |
| 083 | rerere: resolve a recurring conflict once, reuse it forever | ★★★ |
| 084 | Submodules: share a UI kit, bump it, clone it right | ★★★ |
| 085 | git subtree: vendor a library and pull its updates | ★★ |
| 086 | Monorepo tricks: partial clone + sparse-checkout | ★★★ |
| 087 | Config like a pro: aliases, conditional includes, --show-origin | ★★ |
| 088 | .gitattributes: fix the CRLF mess, tame generated files | ★★★ |
| 089 | Sign commits and tags with an SSH key | ★★ |
| 090 | Ship it offline: git archive and git bundle | ★★ |

### 11 · Lead & PM playbook

| # | Exercise | Level |
|---|---|---|
| 091 | Cut and stabilize a release branch | ★★ |
| 092 | Production hotfix from a release tag | ★★★ |
| 093 | Write the release notes from conventional commits | ★★ |
| 094 | Semantic versioning: pick the next version and name the build | ★★★ |
| 095 | Incident commander: bisect, revert, patch release, postmortem | ★★★ |
| 096 | Rescue a 3-month-old long-lived branch | ★★★ |
| 097 | Foxtrot merges and first-parent history | ★★★ |
| 098 | Pull a feature out of the release | ★★★ |
| 099 | Who owns what: find the experts, write CODEOWNERS | ★★ |

### 12 · GitHub for real

| # | Exercise | Level |
|---|---|---|
| 100 | Set up your GitHub lab: gh auth + gh repo create | ★ |
| 101 | Your first pull request with gh (what / why / how to test) | ★ |
| 102 | Issues like a team: labels, milestone, assignee, "Fixes #N" | ★★ |
| 103 | Code review: line comments, a suggestion block, resolve threads | ★★ |
| 104 | Merge commit vs squash vs rebase: merge 3 PRs, compare the graph | ★★ |
| 105 | Main moved: resolve a pull request conflict | ★★ |
| 106 | Protect main: branch protection or a ruleset via gh api | ★★★ |
| 107 | GitHub Actions CI: red check, green check, required check | ★★ |
| 108 | Templates & ownership: PR template, issue forms, CODEOWNERS | ★★ |
| 109 | Releases: tag v1.0.0, generated notes, attach a build | ★★ |
| 110 | Revert a merged PR, then re-land it with a fix | ★★★ |
| 111 | Open-source fork flow (safe): fork, upstream, sync, PR into your fork | ★★ |
| 112 | Dependabot & security basics: alerts, updates, secret scanning | ★★ |
| 113 | Draft & stacked PRs: retarget and rebase after the base merges | ★★★ |
| 114 | Plan work like a PM: GitHub Project, statuses, milestone due date | ★★ |
| 115 | gh power user: pr checkout, run watch, api --jq, alias, search | ★★ |

## How it's tested

Every offline exercise is self-tested on every push (Linux and macOS with the stock `/bin/bash` 3.2): the scenario
is built, the checker must **fail**, the reference solution runs, and the checker must **pass**. Run it yourself
with `test/run-all.sh` (or `test/run-all.sh 22` for one exercise). Want to write your own exercise? See
[CONTRIBUTING.md](CONTRIBUTING.md).
