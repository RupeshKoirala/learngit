# Tags on a remote: push them carefully, fix a wrong one

You're the release manager for Brightcart 2.4.0 this sprint. `main` already has the `Release 2.4.0` commit.

```
* Release 2.4.0                    <- main, origin/main
* Ignore duplicate wishlist items
* Add wishlist                     (tag: tmp-before-refactor)     <- local only, lightweight
* Bump version to 2.3.1
* Fix tax rounding for CA          (tag: v2.3.1)   <- WRONG: VERSION here still says 2.3.0
* Release 2.3.0                    (tag: v2.3.0, bisect-good)     <- bisect-good: local only
* Initial storefront
```

Two problems: you have **private lightweight tags** that must never reach the server, and the release bot put
**`v2.3.1` on the wrong commit** — it should be on `Bump version to 2.3.1`. It's already pushed, and Dev already
has the wrong one in his clone (`.team/dev` in the sandbox).

## Your task

1. Create an **annotated** tag `v2.4.0` on `Release 2.4.0` (message e.g. `Brightcart 2.4.0`) and push **only that
   tag**. `tmp-before-refactor` and `bisect-good` must not end up on origin.
2. Fix `v2.3.1`: it must be an **annotated** tag on `Bump version to 2.3.1`, locally and on origin.
3. `v2.3.0` on origin must stay exactly as it is.
4. Fix Dev's clone too: in `../.team/dev`, make his `v2.3.1` point at the corrected commit. (Try a plain
   `git fetch --tags` there first and read what happens.)

## You'll practice

`git tag -a` vs lightweight tags, `git show <tag>`, `git ls-remote --tags origin`, `git push origin <tag>`,
why `git push --tags` is risky, `git push origin --delete <tag>`, `git tag -f`, and `git fetch --force --tags`.
