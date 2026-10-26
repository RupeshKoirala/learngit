# Push rejected: a teammate pushed first

The storefront team works trunk-based: small changes go straight to `main`. You've finished the free-shipping
banner (two commits) and run `git push`:

```
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to '.../remotes/origin.git'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. This is usually caused by another repository pushing
hint: to the same ref.
```

Dev pushed a fix while you were working. Your history and the remote's have **diverged**:

```
            * Show banner on cart page       <- main (yours)
            * Add free-shipping banner
            |
            | * Round cents before formatting prices   <- main on origin (Dev)
            |/
            * Add itemCount helper            <- origin/main (your last fetch)
```

## Your task

1. Try `git push` yourself and read the message.
2. Integrate Dev's commit by **replaying your two commits on top of it** — the team keeps `main` linear,
   so no merge commit.
3. Push. Afterwards origin's `main` must be: `Add itemCount helper` → Dev's fix → `Add free-shipping banner`
   → `Show banner on cart page`, and your local `main` must match it.
4. Never force-push `main`. Leave the working tree clean.

## You'll practice

Reading a rejected push, `git pull --rebase` (= `git fetch` + `git rebase origin/main`), checking
`git log --oneline --graph` before pushing, and why "fetch first" is not an error to force your way through.
