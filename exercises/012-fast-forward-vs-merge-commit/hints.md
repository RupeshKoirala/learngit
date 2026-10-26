A fast-forward happens when `main` is *behind* the branch on the same line: Git just slides the `main` pointer
forward — no new commit. Look at `git log --oneline --graph --all` and ask for each branch: "is `main` already
in its history?"
---
1. `git merge --ff-only fix/price-rounding`
2. `git merge --no-ff feature/gift-wrap` — Git opens your editor for the merge message; the default
   `Merge branch 'feature/gift-wrap'` is fine, just save and close.
---
`git merge --ff-only feature/loyalty-points` fails with *"Not possible to fast-forward, aborting."* —
because `main` has commits loyalty-points doesn't have. The fork point is
`git merge-base main feature/loyalty-points`.
---
`git merge-base main feature/loyalty-points > ../ANSWER`
If you merged in the wrong order or got an extra merge commit: `git reset --hard <old main hash>` (find it in
`git reflog`) and redo the steps.
