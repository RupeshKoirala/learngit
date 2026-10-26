`git stash push` accepts paths after `--`, just like `git add`:
`git stash push -m "cart: bulk discount wip" -- src/cart.js`. `git status` afterwards should show only
`src/price.js` modified. (`git stash push -p` lets you choose hunk by hunk instead.)
---
Now `git pull` fast-forwards. Then `git add src/price.js` and `git commit -m "Fix formatPrice rounding"`.
Finally `git stash pop`. Expect `CONFLICT (content): Merge conflict in src/cart.js` and the line
"The stash entry is kept in case you need it again."
---
In `src/cart.js`, keep both changes:
```js
function total(cart) {
  if (!cart.items.length) return 0;
  const sum = cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);
  return bulkDiscount(sum, cart.items.length);
}
```
Remove the markers. `git add src/cart.js` marks it resolved (or `git restore --staged src/cart.js` if you
want it back to plain "modified, not staged").
---
Because the pop conflicted, Git did **not** drop the stash — `git stash list` still shows it. Now that your
resolution is in the working tree, drop it yourself: `git stash drop`.
