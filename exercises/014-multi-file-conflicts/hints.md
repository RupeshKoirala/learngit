`git status` shows what Jo left. Throw it away with `git merge --abort` — it resets the index and the
working tree to `main` as it was before the merge. Then `git config merge.conflictStyle diff3`.
---
Run `git merge release/1.4` again and `git status`: two **both modified** files and one
**deleted by us** (modify/delete). Read each conflict with diff3 markers:
`<<<<<<< HEAD` (main) / `||||||| <base>` (the original) / `=======` / `>>>>>>> release/1.4`.
Compare each side with the base to see what each side *changed*. `git diff` now shows a combined diff of only
the unresolved parts. Lost the markers after an edit? `git checkout --conflict=diff3 src/price.js` brings them back.
---
`src/cart.js` is tricky: the diff lined main's new `lineTotal` function up against the old `total`. The base
section shows that main didn't delete `total` — it's still further down. Keep `lineTotal`, delete the
release's copy of `total`, and change the remaining one to
`return Math.round(cart.items.reduce((sum, i) => sum + lineTotal(i), 0));`
---
`src/price.js` should end up as:

```js
function formatPrice(cents, currency = '$') {
  if (cents < 0) return '-' + formatPrice(-cents, currency);
  return currency + (cents / 100).toFixed(2);
}
```
For the deleted file: `git rm src/legacy-coupons.js`, then change `<` to `<=` in `src/discount.js` and
`git add` it. Finally `git add src/cart.js src/price.js` and `git commit`.
