# Solution

```bash
git status                                         # M src/cart.js, M src/price.js
git pull                                           # refused: src/cart.js would be overwritten

git stash push -m "cart: bulk discount wip" -- src/cart.js
git status                                         # only src/price.js modified now
git pull                                           # fast-forward: Dev's commit
./test.sh
git add src/price.js
git commit -m "Fix formatPrice rounding"

git stash pop
# CONFLICT (content): Merge conflict in src/cart.js
# The stash entry is kept in case you need it again.
```

`src/cart.js` now shows:

```
function total(cart) {
<<<<<<< Updated upstream
  if (!cart.items.length) return 0;
  return cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);
=======
  const sum = cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);
  return bulkDiscount(sum, cart.items.length);
>>>>>>> Stashed changes
}
```

Keep both intents:

```js
function total(cart) {
  if (!cart.items.length) return 0;
  const sum = cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);
  return bulkDiscount(sum, cart.items.length);
}
```

```bash
git restore --staged src/cart.js                   # resolved; back to "modified, unstaged" (git add also works)
git stash list                                     # stash@{0}: On main: cart: bulk discount wip  <- still here!
git stash drop
```

**Why it works:** `git stash push -- <paths>` stashes only matching files and leaves the rest of your
changes alone. `pop` is `apply` followed by `drop` — but Git only drops when the apply was clean. On a
conflict it keeps the entry so that, if your resolution goes wrong, you can `git checkout -- src/cart.js`
(or `git reset --hard`) and `git stash apply` again. Dropping is your job, *after* you're happy with the
resolution. Note the marker labels: "Updated upstream" = your current `HEAD`, "Stashed changes" = the stash.

**Real-world notes**
- `git pull --autostash` (or `git config --global rebase.autoStash true` with `pull.rebase=true`) does the
  stash/pull/pop dance for you — great once you understand what it does, confusing if you don't, because
  the conflict appears *after* the pull "succeeded".
- Partial stashing is ideal for exactly this: separate finished work from unfinished work so each commit
  is focused. For bigger splits, `git add -p` + commit is often cleaner than juggling stashes.
- Never `git stash drop` right after a conflicted pop "to tidy up" — that's the only backup of your
  original work until the resolution is done.
- Before resolving, `git stash show -p` shows exactly what your stash contained — handy when the conflict
  region is confusing.
