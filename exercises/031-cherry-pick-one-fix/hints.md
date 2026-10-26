First find the commit. `git log --oneline main..feature/gift-cards` lists the commits on Dev's branch that
`main` doesn't have. `git show <hash>` shows exactly what one of them changes — check it only touches
`src/price.js`.
---
`git cherry-pick <hash>` takes the change introduced by one commit and replays it as a new commit on top of
the branch you're on. So be on `main` first.
---
```bash
git switch main
git cherry-pick <hash-of-"Fix formatPrice for negative amounts">
./test.sh
```
You can also refer to the commit without copying a hash: `feature/gift-cards~2`, or
`':/Fix formatPrice'` (the newest commit whose message matches).
---
Picked the wrong commit? `git reset --hard ORIG_HEAD` undoes the cherry-pick (only do that on commits you
haven't pushed yet).
