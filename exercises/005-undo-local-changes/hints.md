Three different "undo"s for three different areas:
- a modified file in the **working tree** → `git restore <file>` (copies the committed version over it)
- a file in the **staging area** → `git restore --staged <file>` (unstages, keeps your edit)
- **untracked** files → `git clean` (Git never stored them, so they're gone for good)
---
`git restore src/price.js` throws the experiment away — there's no undo for that, so look at
`git diff src/price.js` first. Then `git restore --staged src/cart.js` and check `git status -s`:
cart.js should now show ` M` (modified, not staged).
---
**Always dry-run `git clean`:** `git clean -n -d` lists what *would* be deleted (`-d` includes untracked
folders). Notice `src/coupon.js` is in the list! Exclude it with `-e`:

```bash
git clean -n -d -e src/coupon.js     # check the list
git clean -f -d -e src/coupon.js     # do it
```
Or use `git clean -i -d` and pick interactively. Never add `-x` here: it also deletes ignored files —
your `.env` and `node_modules/`.
---
An alternative for the junk: delete it by hand (`rm -r tmp coverage scratch.txt src/cart.js.orig`). Either
is fine; `git clean -n` just shows you what Git considers untracked so you don't miss anything.
