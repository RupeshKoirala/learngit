# Recover a cleared stash from dangling commits (git fsck)

Yesterday you stashed half a day of work on **express checkout** (changes to `src/cart.js` plus a brand-new
`src/express.js`) to review a teammate's PR. This morning you wanted to throw away an *old* stash — a dark-mode
experiment from two weeks ago — and typed:

```
$ git stash clear
$ git stash list
$                                  <- both stashes gone, including express checkout
```

`git reflog` doesn't help either: stashes live in their *own* reflog (`refs/stash`), and `stash clear` just
deleted it.

But a stash is really a **commit** (the message looks like `On main: express checkout button`). Commits that
no ref points to anymore don't vanish immediately — they become *dangling* objects until garbage collection,
and `git fsck` can list them.

## Your task

1. Find the dangling commit for the **express checkout** stash (not the dark-mode one, and not the other
   unreachable commit that's lying around).
2. Apply it so the express-checkout work is back in your working tree — `src/cart.js` has
   `expressCheckout` again and `src/express.js` exists. Don't commit it.
3. Don't apply the dark-mode experiment. `main` must not move.

## You'll practice

What a stash actually is, `git fsck --unreachable` / `--no-reflogs` / `--lost-found`, `git log --no-walk`,
`git stash apply <commit>` and `git stash store`.
