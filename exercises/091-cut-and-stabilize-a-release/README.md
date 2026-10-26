# Cut and stabilize a release branch

You're the release manager for **Brightcart 2.0**. Maya declared the code freeze two days ago with the commit
`chore(release): code freeze for 2.0.0` — everything up to that commit ships in 2.0. Since then `main` has
already moved on: Dev merged gift wrapping, which Sam (PM) has scheduled for **2.1**.

```
* chore: open 2.1 development              <- main, origin/main
* feat(giftwrap): gift wrapping option       (2.1 only!)
* chore(release): code freeze for 2.0.0    <- the 2.0 cut point
* feat(cart): show item count badge
* feat(price): compact price labels
* feat(checkout): add sales tax to order totals
* chore: initial storefront                  (v1.9.0)
```

QA tested the freeze commit and filed two release blockers (run `./test.sh` to see them fail):

- **BC-201** — tax is 80%, not 8%: in `src/checkout.js`, `TAX_RATE` must be `0.08`.
- **BC-202** — prices show one decimal (`$19.9`): in `src/price.js`, use `toFixed(2)`.

## Your task

1. Create the branch `release/2.0` starting **at the code-freeze commit** (not at the tip of `main`).
2. On `release/2.0`, fix BC-201 and BC-202 as **two separate commits** (so each can be reviewed or reverted
   on its own). `./test.sh` must pass on the release branch.
3. Tag the fixed release-branch commit as `v2.0.0` — an **annotated** tag (it's a real release).
4. Merge `release/2.0` back into `main` so the fixes aren't lost in 2.1. `main` must keep gift wrapping and
   its `VERSION` of `2.1.0-dev`.
5. Push `main`, `release/2.0` **and the tag** to `origin`. Leave a clean working tree.

## You'll practice

Creating a branch from an older commit (`git switch -c <branch> <commit>`, `git log --grep`), annotated tags
(`git tag -a`), merging a release branch back, and pushing tags (`git push --follow-tags` / `git push origin v2.0.0`).
