# Revert a bad commit that's already on shared main

It's 3 p.m. and support is on fire: every price on the site shows **without cents** — `$19.99` appears as
`$20`, and customers are being charged one price and shown another. You trace it to this morning's commit
by Dev:

```
* Document the deploy schedule        (Maya)   <- main, origin/main
* Add NEW badge to product cards      (Lena)
* Show prices as whole dollars        (Dev)    <- the culprit
* Add removeItem to cart              (Dev)
* Initial storefront                  (Maya)
```

It's already pushed, two teammates have built on top of it, and everyone has pulled `main`. Dev is out
today. Maya (tech lead) asks you to undo it **now** — but `main` is shared, so no history rewriting.
(The fake remote is configured like a protected branch: force-pushes are rejected.)

## Your task

1. Undo **only** "Show prices as whole dollars" on `main` by adding a new commit on top. The commits from
   Lena and Maya must stay exactly as they are.
2. Keep Git's conventional revert message (it starts with `Revert "…"`).
3. **Push** it so `origin/main` is fixed, and leave your local `main` in sync with it.

`./test.sh` should pass again afterwards.

## You'll practice

`git revert`, finding the culprit with `git log -p` / `git log -S`, why rewriting a shared branch is off
limits, and pushing a fix the safe way.
