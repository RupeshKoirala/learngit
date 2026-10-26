Run `git status`. Files under *Changes to be committed* are in the **staging area** (the next commit);
files under *Changes not staged* are only in your **working tree**. A commit takes exactly what is staged —
nothing more. `git diff` shows unstaged changes, `git diff --staged` shows what will be committed.
---
Right now both `cart.js` and `price.js` are staged, so a `git commit` would mix them. Take `cart.js` back out
of the staging area without losing your edits: `git restore --staged src/cart.js`
(older Git: `git reset HEAD src/cart.js`).
---
Avoid `git add .` / `git add -A` / `git commit -a` here — they'd grab everything, `notes.txt` included.
Stage by path instead:

```bash
git diff --staged --stat          # only src/price.js?
git commit -m "Fix rounding in formatPrice"
git add src/cart.js README.md
git commit -m "Add removeItem to cart"
```
---
Check each commit with `git show --stat HEAD` and `git show --stat HEAD~1`. Made a mixed commit?
`git reset --soft HEAD~1` undoes the commit but keeps everything staged; `git reset HEAD~1` undoes it and
unstages everything — then try again.
