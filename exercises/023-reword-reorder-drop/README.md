# Reword, reorder and drop commits before review

You're about to open a PR for `feature/wishlist`. The code is fine; the history is not:

```
* add btn                  <- feature/wishlist   (src/product-page.js)
* temp debug                                     (adds src/debug.js — must never ship)
* Document the wishlist                          (README.md)
* asdf                                           (src/wishlist.js)
* Initial storefront       <- main
```

Two meaningless messages, a debug file that dumps customer data to the logs, and the docs commit landed
before the feature it documents. Maya reads PRs commit by commit, and the release-notes script reads commit
subjects. Fix it with one interactive rebase.

## Your task

Rewrite `feature/wishlist` (on top of `main`) into exactly these 3 commits, oldest first:

1. `Add wishlist module` — only `src/wishlist.js` (was "asdf")
2. `Add wishlist button to product page` — only `src/product-page.js` (was "add btn")
3. `Document the wishlist` — only `README.md` (moved to the end)

Rules:
- The "temp debug" commit is **dropped**: `src/debug.js` must not appear in any commit of the branch.
- Every other file ends up exactly as it is now.
- `main` doesn't change; clean tree; no rebase in progress.

## You'll practice

`git rebase -i` with `reword`, `drop` and reordering lines; `git log --stat` to see what each commit touches.
