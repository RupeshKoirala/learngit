# Oops, I committed to main

You started the **wishlist** ticket first thing in the morning, coded for two hours, committed three times…
and just noticed `git status` says **On branch main**. You forgot to create a branch. Luckily you haven't
pushed (and `main` is protected on GitHub anyway).

You're also halfway through the next change (`removeFromWishlist`) — it's **not committed** yet.

```
* Add wishlist tests          <- main (HEAD)   + uncommitted changes in src/wishlist.js
* Add wishlist API route
* Add wishlist store
* Add removeItem to cart      <- origin/main  (as of your last fetch)
* Initial storefront
```

And one more thing you don't know yet: Dev pushed a fix to `main` on GitHub twenty minutes ago.

## Your task

1. Move your 3 commits onto a new branch `feature/wishlist` (same commits, nothing lost, nothing added),
   and end up **on** that branch.
2. Your uncommitted `removeFromWishlist` work must come along: still in the working tree on
   `feature/wishlist`, still **not committed**.
3. Put local `main` back to **exactly where `main` is on the server right now** — not your stale idea of it.
   (`main` should still track `origin/main`.)
4. Don't push anything.

## You'll practice

`git branch` / `git switch -c` to "save" commits under a name, `git fetch`, `git branch -f` to move a branch
you're not on, `git reset` and when `--hard` is dangerous, and how uncommitted changes travel with you when you
switch branches.
