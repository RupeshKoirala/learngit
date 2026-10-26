# Restore one file to its version from an older tag

Since release **v1.3.0**, prices render as `$NaN` for some customers: Dev's new `Intl.NumberFormat` code in
`src/price.js` reads the currency from an environment variable that isn't set everywhere. Dev is on
holiday. Maya decides: **put `src/price.js` back to how it was in v1.2.0**; everything else in v1.3.0 stays.

```
* Mention the changelog                       <- main, tag v1.3.0
* Read default currency from env              (src/price.js)
* Add itemCount to cart                       (src/cart.js)   <- keep!
* Format prices with Intl.NumberFormat        (src/price.js)
* Add removeItem to cart                      <- tag v1.2.0
* Initial storefront
```

You also have **uncommitted work** in `src/cart.js` (a half-done bulk discount). Don't lose it and don't
commit it.

## Your task

1. Make `src/price.js` exactly what it was in tag `v1.2.0`, and commit that as **one** new commit on `main`
   called `Restore v1.2.0 price formatting`. The commit must change only `src/price.js`.
2. Your bulk-discount WIP in `src/cart.js` must still be there, uncommitted.
3. Don't move or delete any tags, don't rewrite history.

## You'll practice

`git restore --source=<rev> <path>` and its older twin `git checkout <rev> -- <path>`, `git diff <tag> -- <path>`,
and committing only part of your working tree.
