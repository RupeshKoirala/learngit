A stash remembers the commit it was made on: it's the stash's first parent. `git log -1 --oneline
stash@{1}^1` shows it. `git stash show -p stash@{1}` shows the changes. Check `git stash list` first — the
loyalty stash isn't `stash@{0}`.
---
`git stash branch <new-branch> <stash>` does four things in one go: creates the branch at the stash's base
commit, switches to it, applies the stash there (no conflict — it's the exact code it was made against),
and drops the stash if that worked.
---
```bash
git status                      # if a failed apply left a mess on main: git reset --hard
git stash branch feature/loyalty-points stash@{1}
git status                      # src/loyalty.js staged (it was staged when you stashed), checkout.js modified
git add -A
git commit -m "Add loyalty points to checkout"
```
---
Don't apply the dark-mode stash by accident: `git stash list` at the end should show just
`experiment: dark mode`. Next step in real life: `git rebase main` on the new branch and resolve the
conflict once, deliberately, with the whole commit in view.
