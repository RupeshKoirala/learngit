Start with `git pull` (it's a fast-forward — you have no local commits). Then find the culprit:
`git log --oneline -- src/price.js` and `git show <hash>`. Run `./test.sh` to confirm it's red.
---
`git revert <hash>` creates a **new** commit that applies the inverse of `<hash>`. Nothing is removed from history,
so teammates just pull it like any other commit. Run `./test.sh` again: green.
---
Now redo the feature properly. The bug was `Math.round(cents / 100).toFixed(0)`; it should be
`(cents / 100).toFixed(2)`. Tip: `git show <bad-hash>:src/price.js > src/price.js` gives you the broken version
back to fix by hand. Commit it with a message that explains the fix.
---
```bash
./test.sh && git commit -am "Add currency support to formatPrice (keep cents)"
git push          # no --force: you only added commits
```
