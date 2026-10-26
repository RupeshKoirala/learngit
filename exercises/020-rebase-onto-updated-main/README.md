# Rebase your feature onto the updated main

Yesterday you branched `feature/free-shipping` off `main` and made two commits. Overnight Dev and Lena merged
their own work, so `main` has moved on without you:

```
* Format prices with thousands separators   <- main  (Lena)
* Add removeItem to cart                             (Dev)
| * Free shipping on orders over $50        <- feature/free-shipping  (you)
| * Add flat-rate shipping cost
|/
* Initial storefront
```

Brightcart's rule: a PR must be up to date with `main` before it's merged, and the team keeps a **linear
history** — no "Merge branch 'main' into feature/…" noise. Maya asks you to rebase. To really *see* what that
means, you'll do it both ways.

## Your task

1. **The merge way (for comparison).** Create a branch `compare/merge` at your *current* feature tip and merge
   `main` into it, producing a real merge commit. Do this **before** step 2.
2. **The rebase way.** Rebase `feature/free-shipping` onto `main`, so your 2 commits sit on top of the current
   tip of `main`.

Then look at `./lg graph` and run `git diff compare/merge feature/free-shipping` (it should print nothing).

The checker wants:
- `feature/free-shipping`: exactly your 2 commits (same messages, same order) on top of `main`, no merge commits,
  and `src/shipping.js` exactly as you wrote it.
- `compare/merge`: a merge commit that contains `main` *and* your original, un-rebased commits.
- Both branches end with identical files. `main` doesn't move. Clean working tree, nothing in progress.

## You'll practice

`git rebase <upstream>`, `git merge` vs `git rebase` side by side, why rebased commits get new hashes,
`ORIG_HEAD`, and `git range-diff` to compare before/after.
