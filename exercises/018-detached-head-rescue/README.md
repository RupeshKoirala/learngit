# Detached HEAD: rescue the commits you left behind

A customer reported that coupons still work for one second after they expire. This morning you ran
`git switch --detach v1.2` to reproduce it on the released version, wrote a failing test, fixed the bug,
committed twice — then got pulled into a meeting and switched back to `main`. Git printed this, and you
didn't read it:

```
Warning: you are leaving 2 commits behind, not connected to
any of your branches:

  ... Fix coupon expiry off-by-one
  ... Add failing test for coupon expiry
```

Since then you also made a commit on `chore/bump-deps`. Now Maya asks: *"Where's the 1.2.1 hotfix?"*
`git log --all` doesn't show it. It isn't gone — it's just not on any branch.

```
* Document Node 20 requirement               <- chore/bump-deps
* Add express shipping option placeholder    <- main (HEAD)
* Start checkout redesign
* Add wishlist                               <- v1.2
| ? Fix coupon expiry off-by-one             <- (nothing points here)
| ? Add failing test for coupon expiry
|/  ...(they hang off v1.2)
* Add removeItem to cart                     <- v1.1
```

Careful: there's also an old **debug** experiment from two weeks ago that was made the same way. That one is
garbage — don't rescue it.

## Your task

1. Create a branch `hotfix/1.2.1` that contains exactly the two lost commits on top of `v1.2`:
   `Add failing test for coupon expiry`, then `Fix coupon expiry off-by-one` (same content).
2. Don't change `main` or the `v1.2` tag. End on a branch (not detached).

## You'll practice

What "detached HEAD" means, `git reflog` (HEAD's diary of everywhere it has been), `git log -g`,
`git branch <name> <hash>` to give a lost commit a name, and `git fsck --lost-found` as a last resort.
