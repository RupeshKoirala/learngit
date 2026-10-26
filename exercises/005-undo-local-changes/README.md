# Undo local changes: restore, unstage and clean safely

Friday afternoon. Your working copy is a mess and you want to get back to a clean state **without losing the
two things that matter**: the coupon work in `src/cart.js` and the brand-new `src/coupon.js`.

```
$ git status -s
M  src/cart.js           staged   — real work (applyCoupon), but staged too early
 M src/price.js          modified — failed Intl experiment, breaks tests
?? coverage/             junk     — test coverage output
?? scratch.txt           junk
?? src/cart.js.orig      junk     — leftover from an old merge
?? src/coupon.js         KEEP     — the new file you're writing
?? tmp/                  junk     — session dumps
```

Also on disk but ignored by `.gitignore`: `.env` (your local API key) and `node_modules/`. Both must survive.

## Your task

1. **Discard** your changes to `src/price.js` (back to the last commit).
2. **Unstage** `src/cart.js` — the edit must stay in the file, just not staged.
3. **Delete** all untracked junk: `scratch.txt`, `src/cart.js.orig`, `tmp/`, `coverage/`.
4. **Keep** `src/coupon.js`, `.env` and `node_modules/` exactly where they are.
5. Don't commit anything — `main` must not move.

End state: `git status -s` shows only ` M src/cart.js` and `?? src/coupon.js`.

## You'll practice

`git restore <file>`, `git restore --staged <file>`, `git clean -n` (dry run!), `git clean -f / -d / -x / -e`,
`git clean -i`, and the difference between untracked and ignored files.
