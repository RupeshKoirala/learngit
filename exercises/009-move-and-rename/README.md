# Move and rename files without losing history

The storefront is growing and Maya agreed on a new layout in the architecture meeting. Your job is the
"big move" PR — and Lena warns you: *"Last time someone moved files, `git log` on them only showed one commit
and `blame` blamed the mover for every line. Don't do that to us."*

```
now                          after your PR
src/cart.js           ->     src/cart/cart.js
src/price.js          ->     src/utils/format-price.js
test.sh               ->     scripts/test.sh
```

## Your task

1. Make **one commit that only moves** the three files above — no content changes at all, so Git detects
   every move as a 100% rename.
2. Then make **a second commit** that updates `README.md` so it tells people to run `./scripts/test.sh`
   (instead of `./test.sh`). Only `README.md` changes in this commit.
3. Using the history of `src/utils/format-price.js`, find the commit that **originally created** this file
   (back when it had another name) and write its hash into `ANSWER` in the sandbox folder
   (`echo <hash> > ../ANSWER`).

`scripts/test.sh` must stay executable. Finish with a clean working tree.

## You'll practice

`git mv`, rename detection (`git status`, `git diff -M --name-status`, `git show --stat`),
`git log --follow`, `git blame` after a move, and the "move first, edit later" rule.
