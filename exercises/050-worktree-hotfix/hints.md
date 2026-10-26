A worktree is another folder with its own checked-out branch, sharing the same `.git` history. From `repo`:
`git worktree add -b hotfix/empty-cart-crash ../hotfix main` creates the folder, the branch, and checks it
out there. Then `cd ../hotfix`.
---
Fix in `../hotfix/src/checkout.js`:
```js
function shippingFor(cart) {
  if (cart.items.length === 0) return 0;
  return cart.items[0].weight > 5000 ? 900 : 499;
}
```
Delete the `// BUG: …` line, run `./test.sh`, then `git commit -am "Fix checkout crash on empty cart"`.
---
To move `main`: `main` isn't checked out anywhere, so inside the worktree you can
`git switch main && git merge --ff-only hotfix/empty-cart-crash`. (A branch can only be checked out in one
worktree at a time — Git will tell you if you try otherwise.)
---
Go back with `cd ../repo`, then `git worktree remove ../hotfix` (it refuses if the worktree has
uncommitted changes — that's a safety net). If you deleted the folder by hand instead, `git worktree prune`
cleans up the leftover bookkeeping. Finally `git status` in `repo` should look exactly like before.
