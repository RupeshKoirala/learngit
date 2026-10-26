# Stage part of a file with git add -p

Support reported that carts with wishlist items show a total of **$NaN** — those items have no `qty` yet.
You fixed `total()` in `src/cart.js`. While you were in there you also added the `clearCart()` helper Lena
asked for, and you sprinkled in a `console.log` to debug things.

All three changes are in the **same file**, so `git add src/cart.js` would grab all of them.

```
src/cart.js (working tree vs last commit)
  @@ addItem    +  console.log('DEBUG addItem', ...)    <- keep locally, never commit
  @@ total      -  ... i.price * i.qty
                +  ... i.price * (i.qty || 1)           <- the bug fix
  @@ bottom     +  function clearCart(cart) { ... }     <- the feature
                ~  module.exports = { ..., clearCart }
```

## Your task

Make exactly **two new commits** on `main`, both touching only `src/cart.js`:

1. `Fix total for items without qty` — only the `total()` fix (with its comment)
2. `Add clearCart helper` — only `clearCart()` and the updated `module.exports`

Order doesn't matter. The `console.log` debug line must **not** be committed, but must **stay** in your
working tree as an unstaged change. Don't retype code — stage the hunks that are already there.

## You'll practice

`git add -p` (patch mode) and its answers `y / n / s / e / q / ?`, `git diff --staged` to review a partial
stage, and `git restore --staged -p` / `git reset -p` to unstage pieces.
