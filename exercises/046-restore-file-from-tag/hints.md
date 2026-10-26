See the difference first: `git diff v1.2.0 -- src/price.js`. A tag, a branch, a hash, `HEAD~3` — any of
them can be a *source* to copy a file from.
---
`git restore --source=v1.2.0 src/price.js` overwrites only that one file in your working tree.
(`git checkout v1.2.0 -- src/price.js` does the same and also stages it.) Careful with
`git checkout v1.2.0` *without* `-- path` — that moves HEAD to the tag instead.
---
Commit **only** the staged file: `git add src/price.js` then `git commit -m "…"` — not `git commit -a`,
which would sweep up your cart.js WIP too.
---
```bash
git restore --source=v1.2.0 src/price.js
git add src/price.js
git commit -m "Restore v1.2.0 price formatting"
git status          # src/cart.js still modified
```
