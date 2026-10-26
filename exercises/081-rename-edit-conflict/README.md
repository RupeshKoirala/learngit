# Merge your edits into a file a teammate moved

You added `formatSalePrice` to `src/price.js` on `feature/sale-prices`, plus a sale banner that uses it.
Meanwhile Lena merged a refactor into `main`: she **moved** `src/price.js` to `src/utils/money.js` *and* added
money parsing helpers at the top of it.

```
* Move price helpers to src/utils/money.js, add parseMoney   <- main (Lena)
| * Add sale banner            <- feature/sale-prices   (src/sale-banner.js requires './price')
| * Add formatSalePrice                                  (edits src/price.js)
|/
* Initial storefront
```

Try `git merge main`. Git reports `CONFLICT (modify/delete): src/price.js deleted in main and modified in HEAD`
and leaves you with *both* `src/price.js` and `src/utils/money.js`. Git didn't recognise the move: the new file is
less than 50 % similar to the old one, so it looks like "delete one file, add an unrelated one".

## Your task

Bring `main` into `feature/sale-prices` (a merge is what the team expects here) so that:

1. Your `formatSalePrice` (function + its `exports.` line) lives in `src/utils/money.js`, next to Lena's
   `parseMoney` and `toCents`. `src/price.js` no longer exists.
2. Nothing requires `'./price'` anymore — `src/sale-banner.js` uses `'./utils/money'`.
3. Your two commits and all of `main` are in the branch's history; `main` itself doesn't change.
4. No conflict markers, nothing in progress, clean working tree.

## You'll practice

Rename detection and its 50 % threshold, `git diff -M<n>% --name-status`, `git merge -X find-renames=<n>%`,
resolving a modify/delete conflict by hand, `git log --follow`, and hunting "semantic conflicts" with `git grep`.
