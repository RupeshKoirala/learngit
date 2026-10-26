# Solution

```bash
git switch main
git merge --ff-only fix/price-rounding       # "Fast-forward" — main just moves up one commit
git merge --no-ff feature/gift-wrap          # creates "Merge branch 'feature/gift-wrap'"
git merge --ff-only feature/loyalty-points   # fatal: Not possible to fast-forward, aborting.
git merge-base main feature/loyalty-points > ../ANSWER
git log --oneline --graph --all
```

Result:

```
*   Merge branch 'feature/gift-wrap'          <- main
|\
| * Document gift wrap                         <- feature/gift-wrap
| * Add gift wrap pricing
|/
* Round fractional cents before formatting     <- fix/price-rounding
* Add free-shipping threshold
| * Document loyalty points                    <- feature/loyalty-points
| * Add loyalty points calculation
|/
* Add removeItem to cart                       <- the fork point (ANSWER)
```

**Why it works**
- **Fast-forward** is possible when `main` is an ancestor of the branch: no work needs combining, so Git
  just moves the pointer. `--ff-only` says "do that or nothing".
- **`--no-ff`** forces a merge commit anyway. Its first parent is the old `main`, its second parent the
  feature tip. That's what makes `git log --first-parent main` read like a list of features, and lets you undo a
  whole feature with `git revert -m 1 <merge>`.
- **loyalty-points** forked at `Add removeItem to cart`; since then `main` gained commits the branch doesn't
  have. Both sides moved, so the only options are a real merge (or rebasing the branch first). `--ff-only`
  refuses, and nothing changes.

**Real-world notes**
- Set `git config --global pull.ff only` (or `merge.ff only` for a repo). Then `git pull` on `main` never
  creates surprise "Merge branch 'main' of github.com…" commits — it fails, and you decide.
- GitHub's three buttons map to this: **Create a merge commit** = `--no-ff`; **Squash and merge** = one new
  commit, no link to the branch; **Rebase and merge** = replay commits, no merge commit. Teams pick one per
  repo in Settings; leads usually pick based on how they want to read and revert history.
- Merge commit vs linear history is a team decision, not a right answer. What matters is consistency and that
  `main` is always green.
