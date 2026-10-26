# Bring back a file deleted several commits ago

A month ago Dev removed the coupon module ("nobody uses coupons anymore"). Now Sam (PM) wants coupons back
for Black Friday — **exactly** the last version that ran in production, including Lena's case-insensitive
fix.

```
* Add shipping cost rules                    <- main
* Mention the changelog
* Add itemCount to cart
* Remove legacy coupon and banner code       <- deleted src/coupons.js (and src/legacy-banner.js)
* Make coupon codes case-insensitive
* Table-driven coupon codes
* ...
```

(The hashes are yours to find — pretend this happened 200 commits ago.)

## Your task

1. Find the commit that **deleted** `src/coupons.js` and write its hash (short is fine) into the file
   `ANSWER` in the sandbox folder (`../ANSWER` from the repo).
2. Restore `src/coupons.js` with exactly the content it had **right before** it was deleted.
3. Commit it on `main` as **one new commit** that changes only that file. `src/legacy-banner.js` stays
   deleted, and nothing else changes. Don't rewrite existing commits.

## You'll practice

`git log --diff-filter=D`, `git log -- <deleted path>`, the `<commit>^` (parent) syntax, and
`git restore --source=<commit> <path>` / `git checkout <commit> -- <path>`.
