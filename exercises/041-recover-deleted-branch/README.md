# Recover a deleted, unmerged branch with the reflog

Friday afternoon cleanup. You ran `git branch -D` on a bunch of stale branches… and one of them was
`feature/wishlist` — three commits of real work you hadn't pushed or merged yet:

```
$ git branch -D feature/wishlist
Deleted branch feature/wishlist (was ???????).
```

The terminal has since scrolled away, so you don't have that hash. `git branch` now shows only `main`.
Sam (PM) wants the wishlist demo on Monday.

Good news: deleting a branch only deletes a *pointer*. The commits are still in your repository, and your
**HEAD reflog** remembers every commit you've had checked out.

## Your task

1. Recreate the branch `feature/wishlist` pointing at **exactly** its old last commit
   ("Document the wishlist"), with all 3 commits.
2. Don't bring back the throwaway branches (`spike/try-new-router`, `feature/old-banner`).
3. `main` must not change.

## You'll practice

`git reflog`, `HEAD@{n}` syntax, `git log -g`, creating a branch from any commit, and why
`git branch -D` is less scary than it looks (and when it *is* scary).
