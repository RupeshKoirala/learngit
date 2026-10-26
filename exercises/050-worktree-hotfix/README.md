# Urgent hotfix mid-feature: fix production in a second worktree

You're deep into `feature/reviews`: one file **staged**, another **modified**, a third **untracked** — a
carefully arranged mess you don't want to disturb. Then the pager goes off:

> **INC-2041** — checkout crashes for anyone with an empty cart. `main` is what's deployed. Fix it now.

```
* Add review model                 <- feature/reviews  (+ staged, unstaged and untracked work)
* Ship faster checkout             <- main  (has the crash: src/checkout.js)
* Initial storefront
```

You could stash, switch, fix, switch back, pop… and hope nothing conflicts. Instead, use a **second
working directory** for the same repository: `git worktree`.

## Your task

1. Add a worktree at **`../hotfix`** (i.e. the sandbox folder, next to `repo/`) on a **new branch
   `hotfix/empty-cart-crash`** starting from `main`.
2. In that worktree, fix `shippingFor()` in `src/checkout.js`: an empty cart returns `0` instead of
   crashing, and remove the `BUG` comment. Commit it as **`Fix checkout crash on empty cart`** — one commit.
3. Bring the fix into `main` (a fast-forward is perfect).
4. Remove the worktree when you're done: `git worktree list` shows only `repo`, and `../hotfix` is gone.
5. Your feature work in `repo` must be **exactly** as you left it: still on `feature/reviews`, same staged,
   unstaged and untracked changes, nothing stashed.

## You'll practice

`git worktree add -b <branch> <path> <start>`, working in two checkouts of one repo at once, updating a
branch that isn't checked out, `git worktree list` / `remove` / `prune`.
