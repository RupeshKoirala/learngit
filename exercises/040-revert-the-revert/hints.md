Ask Git what it thinks is still unmerged: `git log --oneline main..origin/feature/gift-cards`. Only Lena's
fix shows up. Her first two commits are **already ancestors of main** — the revert removed their *changes*,
not their *history*. A plain merge would bring only the fix (and here even conflicts, because the fix edits a
file that main deleted).
---
To get the original changes back you need to undo the undo: `git revert <hash-of-the-Revert-commit>`.
That re-applies everything the merge brought in. Then merge the branch to pick up the fix.
---
```bash
git switch main && git pull
git revert <hash of 'Revert "Merge branch 'feature/gift-cards'"'>     # revert the revert
git merge origin/feature/gift-cards                                   # now brings just the fix
./test.sh
git push origin main
```
---
If you already ran the plain merge and hit a modify/delete conflict, `git merge --abort` and start with
the revert-the-revert. Verify with `git diff origin/feature/gift-cards main -- src/giftcard.js src/cart.js` (must be empty) before
you push.
