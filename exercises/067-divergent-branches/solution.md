# Solution

```bash
git fetch
git log --oneline --graph --all -12

# 1. main: nothing of yours to keep -> fast-forward only
git switch main
git pull --ff-only

# 2. feature/reviews: your commits are private -> rebase them on top
git switch feature/reviews
git pull --rebase
git push

# 3. release/2.5: your commit is published (tag, QA build) -> merge, don't rewrite
git switch release/2.5
git pull --no-rebase            # creates "Merge branch 'release/2.5' of …"
./test.sh
git push

# 4. defaults for this repo
git config pull.rebase true
git config branch.release/2.5.rebase false
git switch main
```

**Why it works:** `git pull` = fetch + reconcile, and there are three ways to reconcile:

| strategy | does | history | use when |
|---|---|---|---|
| `--ff-only` | moves your branch forward, refuses if you have commits | unchanged | branches you only consume (`main` locally) |
| `--rebase` | re-creates your local commits on top of the server's | linear, new hashes for *your* commits | your commits are unpublished |
| merge (`--no-rebase`) | adds a merge commit joining both | non-linear, nothing rewritten | your commits were already seen/tested/tagged/deployed |

The tag is the giveaway on `release/2.5`: a tag names a commit by hash. A rebase would create a different
"Bump version to 2.5.1" commit, so the branch would no longer contain the build QA approved — release managers
lose traceability ("is rc1 in 2.5.1?"). `branch.<name>.rebase` overrides `pull.rebase` for one branch.

**Real-world notes**
- A sensible personal default: `git config --global pull.rebase true` + `rebase.autoStash true`. Some people
  prefer `pull.ff only` globally so *every* divergence becomes a conscious decision.
- `git pull --rebase` with local *merge* commits flattens them; add `--rebase=merges` (or
  `pull.rebase=merges`) to keep them.
- Release branches usually get changes via PRs or cherry-picks, and are protected; reconciling by hand on them is a
  smell. A lead's job: write the team's choice down (CONTRIBUTING.md: "rebase your feature branches, never rebase
  release/*, main is merge-queue only") and enforce with branch protection ("Require linear history" on `main`).
- Before choosing, `git log --oneline HEAD...@{u} --left-right` shows `<` your side and `>` theirs.
