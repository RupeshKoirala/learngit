# Solution

```bash
git log --oneline --reverse main..feature/checkout-redesign
# 1111111 Redesign: grid layout for checkout
# 2222222 Redesign: bigger headings
# 3333333 a11y: add alt text to cart image        <- A (first)
# 4444444 a11y: label the remove-item button
# 5555555 a11y: visible focus outline             <- B (last)
# 6666666 Redesign: gradient pay button (DO NOT SHIP yet)

# 1) release/2.0: three 1:1 copies
git switch release/2.0
git cherry-pick 3333333^..5555555
git log --oneline -4

# 2) main: one combined commit
git switch main
git cherry-pick -n 3333333^..5555555     # applies all three, commits nothing
git status                               # three files' worth of changes, staged
git commit -m "Accessibility fixes for checkout audit"
```

**Why it works:** `X..Y` is Git's range syntax everywhere (`log`, `rev-list`, `cherry-pick`): "reachable
from Y, minus everything reachable from X". It's a *set difference*, so the left end is excluded —
`3333333..5555555` would silently skip the alt-text fix. `3333333^..5555555` starts from the parent and
includes all three. Cherry-pick then replays them in history order (oldest first).

`-n` (`--no-commit`) does the apply step for each commit but skips the commit step, accumulating the
changes in the index. One `git commit` at the end gives you a single commit. (Equivalent alternatives:
pick normally and squash with `git reset --soft HEAD~3 && git commit`, or `git merge --squash` — but the
latter only works when you want *everything* from a branch.)

**Real-world notes**
- Always check a range before picking it: `git log --oneline A^..B`. That's exactly the list cherry-pick
  will apply. One wrong `^` and you either skip a commit or drag in an extra one.
- If a range pick conflicts halfway, Git stops on that commit: fix it, `git add`, `git cherry-pick
  --continue`. `--abort` rolls back the *whole* sequence, `--skip` drops just the current commit (033).
- A squashed copy on `main` is invisible to `git cherry`/patch-id matching (it's one diff, not three), so
  later tooling can't tell those a11y commits already landed. Mention the originals in the message body
  (e.g. "Cherry-picked from 3333333..5555555") — the squash loses that link otherwise.
- The healthiest fix is upstream of all this: Lena splits the a11y work into its own small PR merged to
  `main`, and the release branch cherry-picks from `main` — "fix on main first, then backport" (034).
