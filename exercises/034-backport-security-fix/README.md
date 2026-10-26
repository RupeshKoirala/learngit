# Backport a security hotfix to two release lines with -x

Security report **SEC-112**: a product named `<script>…</script>` runs JavaScript in every shopper's
browser when it appears in search results (stored XSS). Maya fixed it on `main` this morning. Brightcart
still supports two older release lines for big wholesale customers, and both are vulnerable:

```
* Start 1.5 development                               <- main
* Escape product names in search results (SEC-112)   <- the fix
* Add search suggestions
* Release 1.4.0          (v1.4.0)                    <- release/1.4
* Add stock check
* Rename product.title to product.name
| * Release 1.3.2        (v1.3.2)                    <- release/1.3
| * Hide .00 on whole prices
|/
* Release 1.3.0          (v1.3.0)
```

Policy (Maya): "Every backport is cherry-picked **with `-x`**, so auditors can trace each patch release
back to the original fix on `main`."

## Your task

1. `release/1.4` gets exactly **one** new commit: the SEC-112 fix, with the same subject and a
   `(cherry picked from commit <full hash of the fix on main>)` line in its message.
2. `release/1.3` gets exactly **one** new commit, same rules. Heads-up: in 1.3 the field was still called
   `product.title` — the escaped field there must be `product.title` (1.3 has no `product.name`).
3. Tag the new tips as the patch releases: **`v1.4.1`** on `release/1.4`, **`v1.3.3`** on `release/1.3`.
4. Only the fix travels: `src/suggest.js` must not appear on either release branch; `main` unchanged.
5. Clean tree, no cherry-pick in progress, no conflict markers.

## You'll practice

`git cherry-pick -x`, resolving a backport conflict against older code, and tagging patch releases.
