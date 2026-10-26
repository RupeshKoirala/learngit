# Solution

```bash
m=$(git log --format=%H --merges -1 --grep='#42' main)
git diff --stat $m^1 $m          # src/wishlist.js, templates/product.html — the feature
git diff --stat $m^2 $m          # the *other* side: footer typo fix (what main had that Lena didn't)

git switch release/2.4
git cherry-pick -x -m 1 -e $m
#   subject -> Add wishlist (backport of PR #42)
#   keep    -> (cherry picked from commit <m>)
git show --stat
```

What does **not** work:

| Attempt | Result |
|---|---|
| `git cherry-pick $m` | `error: commit … is a merge but no -m option was given.` |
| `git merge lena/wishlist` | brings `recommend.js` too — Lena's branch *contains* it |
| `git cherry-pick -m 2 $m` | replays the diff from Lena's side: the footer typo fix, not the feature |
| `git cherry-pick main~1^2~2^..main~1^2` (the 3 commits) | works too, but gives 3 commits instead of the one auditable "PR #42" unit asked for |

**Why it works:** cherry-pick applies "the diff between a commit and its parent". A merge has two parents,
so you choose: `-m 1` = diff against the first parent (the branch you merged *into*, i.e. `main` before
the PR) = "everything this PR brought to `main`". That diff contains only the wishlist work — the
recommendations engine was already in `M^1`, so it isn't part of the diff. That's the key insight: a
merge's first-parent diff is the PR, no matter where the feature branch started.

**Real-world notes**
- Backporting a whole feature (not a fix) to a release line is a **product decision** with real risk —
  more code, less soak time. A good lead asks: is it behind a feature flag? Does it depend on anything else
  in 2.5? Who tests the 2.4 build? Write the answers in the backport PR.
- After a `-m 1` pick, Git does **not** consider the feature "merged" into the release: if you later merge
  `main` into `release/2.4` (some teams do), Git sees the same changes twice; usually fine, sometimes
  conflicts. Pick a strategy (cherry-pick backports *or* merge-down) and stick to it.
- `git log --first-parent main` shows `main` as a list of merged PRs — the same "mainline" idea `-m 1` uses.
  Teams that always merge with `--no-ff` get this clean PR-level history for free.
- If the feature had been squash-merged on GitHub, there'd be no merge commit — just a plain commit you'd
  pick normally. Merge-commit vs squash policy affects how easy backports are; worth knowing when your team
  debates it.
