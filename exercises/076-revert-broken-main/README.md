# Broke main, team pulled: revert, then fix forward

Sam (PM) in #incidents: *"Prices on staging show **$20** instead of **$19.99**. Release is at 15:00."*

It's your commit. `Add currency support to formatPrice` rounds away the cents, and `./test.sh` on `main` fails.
Worse, it's been on `origin/main` for an hour: Maya pulled it and pushed a commit on top, Lena pulled it too.

```
origin/main:
* Show cart total in header            (Maya, you haven't fetched it yet)
* Add currency support to formatPrice  (you — the breaking commit)
* Add cart item count
* Initial storefront
```

Resetting `main` and force-pushing would yank commits out from under Maya and Lena. Shared history only
moves forward.

## Your task

1. Bring your `main` up to date with `origin/main`.
2. Undo the breaking commit with **`git revert`** (keep Git's `This reverts commit <hash>.` line). Main is green
   again — in real life you'd push this revert *right now* to unblock the release.
3. **Fix forward:** in a new commit after the revert, bring currency support back *correctly*:
   `formatPrice(cents, currency)` with the `EUR ` / `$` symbol, keeping two decimals (`toFixed(2)`).
   `./test.sh` must pass.
4. Push to `origin` **without rewriting history**: the breaking commit and Maya's commit stay in `origin/main`.
5. Clean working tree, `main` == `origin/main`.

## You'll practice

`git log -- <path>`, `git revert`, revert vs reset on shared branches, fix-forward, and `git push` without force.
