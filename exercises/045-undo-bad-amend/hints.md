`git commit --amend` doesn't edit a commit — it creates a **new** one and moves the branch to it. The old
commit still exists. `git reflog` shows both: `commit (amend): …` on top and the original commit right
below it.
---
`HEAD@{1}` means "where HEAD was one move ago" — here, the original, un-amended commit. Check:
`git show --stat 'HEAD@{1}'` lists only `src/email.js`.
---
`git reset --soft 'HEAD@{1}'` moves the branch back to the original commit **without touching the index**.
The index still contains the amended snapshot, so the difference — your price.js fix — shows up as staged.
---
```bash
git reset --soft 'HEAD@{1}'
git status                       # src/price.js staged
git commit -m "Fix price rounding"
```
