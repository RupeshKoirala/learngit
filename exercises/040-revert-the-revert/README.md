# Revert the revert: re-land a fixed, reverted feature

Yesterday the gift-card merge broke `main` and Maya reverted it (exercise 039). Today Lena pushed the fix to
her branch and asks you to get gift cards back into `main`.

```
* Announce holiday sale                         (Sam)    <- main, origin/main
* Revert "Merge branch 'feature/gift-cards'"    (Maya)
* Add support address to README                 (Dev)
*   Merge branch 'feature/gift-cards'           (Maya)
|\
| | * Reject redemptions above the card balance (Lena)   <- origin/feature/gift-cards
| |/
| * Redeem gift cards at checkout               (Lena)
| * Add gift card model                         (Lena)
* | Add shipping cost rules                     (Dev)
|/
* ...
```

"Just merge the branch again," says Jo, the new hire. Try it in your head first: what does Git think is
*new* on `feature/gift-cards` compared with `main`?

## Your task

1. Get the **whole** gift-card feature — Lena's original two commits *and* her fix — live on `main`, and make
   sure `feature/gift-cards` ends up **merged** into `main` (so its PR shows as merged).
2. Afterwards `src/giftcard.js` and `src/cart.js` on `main` must be exactly as on `feature/gift-cards`, while
   Dev's shipping rules and Dev's and Sam's README lines stay as they are.
3. Don't rewrite shared history (force-pushes are rejected anyway). **Push** `main` and leave your local
   `main` in sync with `origin/main`.

## You'll practice

Why a reverted merge "poisons" a later re-merge, reverting a revert, merging after a revert, and explaining
it to a teammate.
