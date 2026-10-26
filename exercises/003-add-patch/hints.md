`git diff src/cart.js` shows three separate **hunks** (blocks starting with `@@`). `git add -p src/cart.js`
walks through them one at a time and asks *Stage this hunk [y,n,q,a,d,s,e,?]?*
---
Answer per hunk: `y` = stage it, `n` = skip it, `q` = stop. For the first commit, say `n` to the debug hunk,
`y` to the `total()` hunk and `n` to the `clearCart` hunk. Then check with `git diff --staged` before
committing — that's exactly what the commit will contain.
---
```bash
git add -p src/cart.js          # n, y, n
git diff --staged               # only the total() fix?
git commit -m "Fix total for items without qty"
git add -p src/cart.js          # n, y
git commit -m "Add clearCart helper"
git diff                        # only the console.log line is left
```
If two changes ever land in the same hunk, press `s` to split it into smaller hunks, or `e` to edit the
hunk by hand (delete the `+` lines you don't want).
---
Staged the wrong hunk? `git restore --staged -p src/cart.js` lets you unstage hunk by hunk.
Already committed it? `git reset --soft HEAD~1` brings the commit back to the staging area.
