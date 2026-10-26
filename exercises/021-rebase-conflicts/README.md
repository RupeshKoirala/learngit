# Rebase with conflicts: --continue, --skip, --abort

Your branch `feature/currency` has three commits. While you were working, two things landed on `main`:

```
* Show refunds as negative prices                    <- main  (Lena, edits formatPrice)
* Hotfix: total() crashes when a cart has no items          (Maya)
| * Show the order total in the shop's currency      <- feature/currency (you)
| * Support a currency symbol in formatPrice
| * Fix total() crashing on a cart without items
|/
* Initial storefront
```

Production broke on an empty cart last night, so Maya wrote **her own version of your fix** and shipped it
straight to `main`. And Lena changed `formatPrice` — the same function you changed. Rebasing will stop twice.

## Your task

0. Warm-up (not checked, but do it): start `git rebase main`, look at the first conflict, then
   `git rebase --abort` and confirm with `git log --oneline` that your branch is exactly as before.
   That's your emergency exit — knowing it's there makes conflicts much less scary.
1. Rebase `feature/currency` onto `main` for real.
2. Your empty-cart fix is **already on main** (Maya's version is even a bit stricter). Don't merge the two —
   drop your commit from the branch.
3. In `src/price.js`, keep **both** features: your `symbol` parameter (default `'$'`) *and* Lena's handling of
   negative amounts. The result should be:

   ```js
   function formatPrice(cents, symbol = '$') {
     const sign = cents < 0 ? '-' : '';
     return sign + symbol + (Math.abs(cents) / 100).toFixed(2);
   }
   ```

Done means: `feature/currency` = `main` + exactly 2 commits (`Support a currency symbol in formatPrice`, then
`Show the order total in the shop's currency`), `src/cart.js` identical to main's, no conflict markers,
`src/summary.js` unchanged, clean tree, no rebase in progress.

## You'll practice

Reading a conflict mid-rebase (`git status`, "ours" vs "theirs" during a rebase), `git rebase --continue`,
`git rebase --skip`, `git rebase --abort`, and `git diff` of a conflicted file.
