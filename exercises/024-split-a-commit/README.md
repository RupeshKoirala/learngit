# Split one commit into two

Your PR `feature/reviews` is almost ready:

```
* Show average rating on product page            <- feature/reviews
* Add star rating widget + fix price rounding    (src/rating.js AND src/price.js)
* Add product reviews model
* Initial storefront                             <- main
```

Sam (PM) just pinged: customers are being charged `$10.005`-style amounts after discounts, and he wants the
**price rounding fix** hot-fixed to production today — without the half-finished reviews feature. Maya can
cherry-pick the fix, but only if it's its own commit. Right now it's tangled into the widget commit.

## Your task

Split the middle commit so `feature/reviews` has exactly these 4 commits on top of `main`, oldest first:

1. `Add product reviews model` (unchanged)
2. `Fix price rounding for fractional cents` — only `src/price.js`
3. `Add star rating widget` — only `src/rating.js`
4. `Show average rating on product page` (unchanged)

The fix comes *before* the widget so it can be cherry-picked cleanly. The final files must be exactly what you
have now; `main` doesn't change; clean tree; no rebase in progress.

## You'll practice

`git rebase -i` with `edit`, `git reset HEAD^` (un-commit but keep the changes), staging per file or with
`git add -p`, committing twice, and `git rebase --continue`.
