# Multi-file conflicts, modify/delete, abort and redo with diff3

Release **1.4.1** went out last week from `release/1.4` with three hotfixes. Those fixes must now be
**merged back into `main`**, otherwise the next release (built from `main`) would bring the bugs back.

Jo (new hire) started the back-merge yesterday, got scared by the conflicts, ran
`git checkout --theirs src/cart.js` ("just take the release version"), staged it, and went home. You're taking
over. Jo's half-merge is still in progress on `main`.

```
* Replace legacy coupons with the discount module   <- main (HEAD, merge in progress)
* Support a currency symbol in formatPrice
* Extract lineTotal helper
| * Release 1.4.1                                    <- release/1.4, v1.4.1
| * Coupons expire at their expiry instant, not after
| * Format refunds (negative amounts) correctly
| * Round cart totals to whole cents
|/
* Brightcart 1.4.0                                   <- v1.4.0
```

## Your task

1. Don't trust Jo's half-done state: **abort** the merge.
2. Configure this repo to show conflicts in **diff3** style (`merge.conflictStyle` = `diff3`, or `zdiff3` on
   git ≥ 2.35), so every conflict also shows the common ancestor's version. Setting it globally is fine too.
3. Merge `release/1.4` into `main` again and resolve **every** file, keeping both sides' intent:
   - `src/cart.js` — keep main's `lineTotal` helper **and** the release's rounding: `total()` must use
     `lineTotal` *and* `Math.round`. Exactly one `total` function.
   - `src/price.js` — keep main's `currency` parameter **and** the refund fix. The negative-amount branch
     must keep the caller's currency (`formatPrice(-cents, currency)`).
   - `src/legacy-coupons.js` — `main` deleted it on purpose (coupons moved to `src/discount.js`), the release
     fixed a bug in it. Keep it **deleted**, but port the fix (`expires <= now`) into `src/discount.js`.
   - `CHANGELOG.md` merges cleanly — the 1.4.1 notes must be in the result.
4. Commit the merge. `release/1.4` must not change.

## You'll practice

`git merge --abort`, `git status` during a multi-file conflict, `merge.conflictStyle diff3`,
`git checkout --conflict=diff3 <file>`, `git diff` (combined diff) while conflicted, resolving a
**modify/delete** conflict with `git rm`, and editing a file that isn't even in conflict as part of a merge.
