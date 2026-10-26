# Production hotfix from a release tag

It's Friday, 16:40. **v2.0.0 is live** and support is on fire: customers whose order is *exactly* $50.00 are
charged shipping, even though the site promises "free shipping from $50". Sam (PM) wants a fix out today.

The bug is one character in `src/shipping.js`:

```js
if (totalCents > FREE_SHIPPING_FROM) return 0;     // should be >=
```

But `main` has moved on since 2.0.0 — it contains **unreleased** work (loyalty points, new carriers) that
must **not** go out in a hotfix:

```
* feat(shipping): add DHL and UPS carriers    <- main, origin/main   (unreleased)
* chore: open 2.1 development                                         (VERSION 2.1.0-dev)
* feat(loyalty): earn points on every order                           (unreleased)
* chore(release): 2.0.0                       (tag v2.0.0)            <- what's in production
* ...
```

## Your task

1. Create the branch `hotfix/2.0.1` from the tag `v2.0.0`.
2. Fix the bug (`>=`), and set `VERSION` to `2.0.1`. `./test.sh` must pass.
3. Tag the result as `v2.0.1` (**annotated**). The difference between `v2.0.0` and `v2.0.1` may only touch
   `src/shipping.js`, `VERSION` (and optionally `CHANGELOG.md`) — none of `main`'s unreleased work.
4. **Forward-port** the fix to `main` — with `git cherry-pick -x` or by merging the hotfix branch. Afterwards
   `main` must have the fix, keep its unreleased work, and still say `VERSION` `2.1.0-dev`.
5. Push `main`, `hotfix/2.0.1` and the tag `v2.0.1` to `origin`. Leave a clean working tree.

## You'll practice

Branching from a tag, keeping a hotfix minimal, `git diff --stat v2.0.0 v2.0.1` as a release-review tool,
`git cherry-pick -x` (and why it's a 3-way merge, not a patch copy), and resolving a version-file conflict.
