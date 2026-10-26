# Solution

```bash
cd repo
git remote add pricing-rules ../remotes/pricing-rules.git
git subtree add  --prefix=vendor/pricing-rules pricing-rules v1.0.0 --squash
git subtree pull --prefix=vendor/pricing-rules pricing-rules v1.1.0 --squash

git log --graph --oneline
# *   bf7d5d5 Merge commit '…' (or your -m message)
# |\
# | * 8699592 Squashed 'vendor/pricing-rules/' changes from 6c40a65..bfbf567
# * | 113bc2a Merge commit '2040061…' as 'vendor/pricing-rules'
# |\|
# | * 2040061 Squashed 'vendor/pricing-rules/' content from commit 6c40a65
# * c55542c chore(price): note shared rounding todo
git log -1 --format=%B HEAD^2       # … git-subtree-dir / git-subtree-split: <upstream v1.1.0>
git fetch pricing-rules && git diff pricing-rules/main HEAD:vendor/pricing-rules   # empty = identical
```

**Why it works:** `subtree add` fetches the ref, then (with `--squash`) creates one parentless commit holding
upstream's whole tree, and merges it into your branch *shifted into* `vendor/pricing-rules/` (a subtree
merge). The squash commit's message records `git-subtree-split: <upstream commit>`. `subtree pull` reads that
trailer to know which upstream commit you have, squashes upstream's new commits (v1.0.0..v1.1.0) into one
more commit whose parent is the previous squash, and merges again. The result is ordinary files in ordinary
commits: clones, CI, `git archive` and GitHub's ZIP download all just work, and nobody needs to know subtree
exists except whoever updates the library.

**Subtree vs submodule vs package manager**

| | Subtree | Submodule | Package (npm, Maven…) |
|---|---|---|---|
| Consumers need special commands | no | yes (`--recurse-submodules`) | install step |
| Library code is in your repo | yes (copy) | no (a pointer) | no |
| Easy to patch locally | yes, just commit | awkward | no (fork / patch-package) |
| Repo size | grows with the library | tiny | tiny |
| Best for | small libs, vendoring, docs, forks | big independent projects | anything with a registry |

**Real-world notes**
- Always pass `--squash` consistently for a given prefix; without it you import upstream's full history,
  which is sometimes wanted (merging a whole project into a monorepo while keeping blame).
- You may patch vendored code in place. To send fixes upstream: `git subtree push --prefix=vendor/pricing-rules
  pricing-rules fix/my-patch` (it runs `git subtree split` to extract only the commits touching that folder).
  Keep vendored edits in separate commits so this stays clean.
- `git fetch pricing-rules` also brings the library's **tags** into your repo, where they can clash with
  your own `v1.1.0`. Consider `git config remote.pricing-rules.tagOpt --no-tags`.
- Write down where vendored code came from (the trailers do, but a `vendor/README` with the update command
  saves the next person a search). And check licences before vendoring third-party code.
- Under the hood it's a script (`git-subtree.sh` from `contrib/`): it ships with most Git installers, but
  some minimal Linux packages need `git-subtree` installed separately.
