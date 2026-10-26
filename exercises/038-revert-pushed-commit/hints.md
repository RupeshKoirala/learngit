Find the culprit's hash: `git log --oneline` or, smarter, `git log -S "Math.round" --oneline -- src/price.js`
(the "pickaxe" finds the commit that added that text). Don't `reset` — that would rewrite commits Lena and
Maya already have.
---
`git revert <hash>` creates a **new** commit that applies the exact opposite of `<hash>`'s diff. History
only grows, so everyone can simply pull it.
---
```bash
git revert <hash-of-"Show prices as whole dollars">     # accept the default message
./test.sh
git push origin main
```
---
If the editor opens for the message, just save and close (the default `Revert "…"` text plus
`This reverts commit <hash>.` is exactly what you want). Check with `git log --oneline origin/main -3`.
