# Revert a merge commit that broke main (-m 1)

Lena's gift-card PR was merged into `main` an hour ago. Since then, customers have been redeeming the same
gift card over and over — balances go negative. Maya decides: **pull the whole feature out of `main` now**,
Lena will fix it on her branch and re-land it later.

```
*   ... Add support address to README                (Dev)     <- main, origin/main
*   ... Merge branch 'feature/gift-cards'            (Maya)    <- the PR merge
|\
| * ... Redeem gift cards at checkout                (Lena)
| * ... Add gift card model                          (Lena)
* | ... Add shipping cost rules                      (Dev)
|/
*   ... Add removeItem to cart
*   ... Initial storefront
```

`main` is shared and protected (force-pushes are rejected). Dev's README commit after the merge must stay.

## Your task

1. On `main`, add **one** commit that undoes everything the gift-card merge brought in (both of Lena's
   commits) — and nothing else. Dev's "Add shipping cost rules" (which came in through main's side of the
   merge) must survive.
2. Keep Git's default revert message (`Revert "Merge branch 'feature/gift-cards'"`).
3. Push it, and leave your local `main` in sync with `origin/main`.
4. Don't touch `feature/gift-cards` on the remote — Lena still needs it.

## You'll practice

Reverting a **merge** commit with `git revert -m 1`, what "mainline parent" means, reading `git log --graph`
and `git show` on a merge.
