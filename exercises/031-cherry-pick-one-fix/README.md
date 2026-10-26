# Cherry-pick one bug fix from a teammate's unfinished branch

Support escalated ticket #311: refunds show up as `$-5.00` instead of `-$5.00`, and `./test.sh` on `main`
has been red ever since Lena flagged it. Good news: Dev already fixed it. Bad news: the fix lives on his
**unfinished** `feature/gift-cards` branch, sandwiched between WIP commits that must not reach production
(one of them even hardcodes a test gift card worth $1000).

```
* WIP: hardcode test card              <- feature/gift-cards
* WIP gift card redemption at checkout
* Fix formatPrice for negative amounts     <- the one you want
* WIP gift card model
| * Add free-shipping banner           <- main
|/
* Show refunds in order history
* Add removeItem to cart
* Initial storefront
```

Dev is out today. Maya (tech lead): "Don't merge his branch. Just take the fix."

## Your task

1. Put **only** Dev's commit `Fix formatPrice for negative amounts` on top of `main`
   (exactly one new commit, same message, same change, Dev still credited as the author).
2. None of the gift-card work may reach `main` (`src/giftcard.js` must not exist there).
3. Don't change `feature/gift-cards` — Dev will keep working on it.
4. Finish on `main` with a clean working tree; `./test.sh` passes.

## You'll practice

`git log --oneline main..feature/gift-cards` to find the commit, `git show` to inspect it,
`git cherry-pick <hash>`, and understanding that a cherry-pick creates a **new** commit (new hash, same change).
