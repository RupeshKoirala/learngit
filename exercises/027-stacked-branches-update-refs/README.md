# Rebase a stack of dependent branches with --update-refs

Maya asked for the checkout rewrite as three **small, stacked PRs** instead of one 2,000-line monster. Each PR
builds on the one below it:

```
* Add removeItem to cart              <- main  (new since you started)
| * Show order confirmation           <- feature/checkout-3-ui     (PR #3, based on #2)
| * Add checkout page
| * Add POST /orders endpoint         <- feature/checkout-2-api    (PR #2, based on #1)
| * Validate order addresses          <- feature/checkout-1-model  (PR #1, based on main)
| * Add Order model
|/
* Initial storefront
```

`main` moved on, and the team wants all three PRs up to date. Rebasing them one by one is tedious and
error-prone: rebase only the top branch and the two lower branch pointers stay behind on the old commits.

## Your task

Rebase the **whole stack** onto the current `main` so that:

- `feature/checkout-1-model` = `main` + its 2 commits
- `feature/checkout-2-api` = `feature/checkout-1-model` + its 1 commit
- `feature/checkout-3-ui` = `feature/checkout-2-api` + its 2 commits

All three branch pointers must move (no branch may still point at the old commits). Each branch keeps its
commit messages and adds only its own file (`src/order.js`, `src/order-api.js`, `src/checkout-page.js`).
`main` doesn't change. Clean tree, no rebase in progress.

Tip: do it with **one** rebase command (needs Git 2.38+; `git --version`).

## You'll practice

`git rebase --update-refs`, the `update-ref` lines in an interactive todo list, the `rebase.updateRefs` setting,
and the manual fallback with `git rebase --onto`.
