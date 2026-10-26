# Committed on the wrong feature branch

You juggle two tickets: **wishlist** (`feature/wishlist`) and **search filters** (`feature/search-filters`).
On Wednesday you went back to wishlist work — but forgot to switch branches. Your last two commits are
wishlist commits sitting on the **search** branch. Maya is about to review the search PR and would be
rightly confused by a heart button in it.

```
* Show wishlist count badge      <- feature/search-filters (HEAD)   wrong branch!
* Add wishlist heart button                                         wrong branch!
* Add brand filter
* Add price range filter
| * Add wishlist store           <- feature/wishlist
|/
* Add removeItem to cart         <- main
* Initial storefront
```

Nothing is pushed yet.

## Your task

1. `feature/wishlist` gets the two wishlist commits on top of `Add wishlist store`, in the same order,
   with the same messages and the same file contents (3 commits on top of `main` in total).
2. `feature/search-filters` ends at `Add brand filter` — exactly the commit it had before the mistake.
3. Nothing is lost, `main` doesn't change, no operation is left in progress, the working tree is clean.

## You'll practice

`git cherry-pick <range>`, `A..B` range notation, `git reset --hard <commit>` (and why it's fine here), and
the "name it first, then move pointers" habit. Alternative routes: `git rebase --onto`.
