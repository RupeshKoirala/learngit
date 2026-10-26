# Split a 1,500-line commit into three stacked PRs

You spent a week on the checkout revamp and committed it all at once. Maya opens the PR, sees **+1,475 lines in
one commit** and replies: *"I can't review this. Split it: tax first, then shipping, then the UI — three small
PRs, each on top of the previous one."*

```
* Checkout revamp: tax, shipping, summary UI, docs   <- feature/checkout-revamp
* Add removeItem to cart                             <- main
* Initial storefront
```

What's in the commit (`git show --stat feature/checkout-revamp`):

| Feature | Files |
|---|---|
| Tax | `src/tax.js`, `src/tax-rates.js` |
| Shipping | `src/shipping.js`, `src/shipping-zones.js` |
| Checkout UI (uses both) | `src/checkout-ui.js`, `src/cart.js`, `README.md` |

## Your task

Create three **stacked** branches:

1. `feature/tax` — based on `main`, adds **only** the two tax files.
2. `feature/shipping` — based on `feature/tax`, adds **only** the two shipping files.
3. `feature/checkout-ui` — based on `feature/shipping`, contains **only** the UI, `cart.js` and README changes.

Rules: each branch has at least one commit and no merges; the final files on `feature/checkout-ui` must be
**exactly** those of the giant commit; `main` doesn't move. Whether you keep `feature/checkout-revamp` is up to
you. Finish with a clean working tree.

## You'll practice

`git switch -c <branch> <start>`, `git checkout <commit> -- <paths>` (or `git restore --source`),
`git reset HEAD~` + `git add -p`, `git diff --stat A B`, and how stacked PRs are based on each other.
