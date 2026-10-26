# Stash only some files, and survive a stash pop conflict

You have two unrelated things going on in your working tree on `main`:

- `src/price.js` — a **finished** fix: fractional cents (e.g. `1999.5`) are now rounded before formatting.
- `src/cart.js` — a **half-done** bulk discount (5% off for 10+ items). Not ready.

Dev just told you he pushed "Return 0 early for empty carts" and you should pull it before committing
anything. You try:

```
$ git pull
error: Your local changes to the following files would be overwritten by merge:
        src/cart.js
```

Only `src/cart.js` is in the way. Your price fix can stay right where it is.

## Your task

1. Stash **only** `src/cart.js` (name it, e.g. `cart: bulk discount wip`). Leave `src/price.js` in your
   working tree.
2. Pull Dev's commit, then commit the price fix on top of it as **`Fix formatPrice rounding`**
   (that commit touches only `src/price.js`).
3. Bring the bulk-discount work back with `git stash pop`. It will conflict with Dev's change. Resolve it so
   `total()` has **both** Dev's empty-cart early return **and** your `bulkDiscount` call.
4. Notice what happened to the stash after the conflicted pop, and clean up: when you're done the stash list
   is **empty**, nothing is left in a conflicted state, and the cart work is still **uncommitted** in your
   working tree.

## You'll practice

`git stash push -- <path>` (and `git stash push -p` for picking hunks), `git pull`, resolving a stash
conflict, and why a conflicted `pop` keeps the stash.
