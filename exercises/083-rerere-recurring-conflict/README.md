# rerere: resolve a recurring conflict once, reuse it forever

You've been building multi-currency prices on `feature/multi-currency` for a week. Meanwhile Maya refactored
`formatPrice` on `main` to use `Intl.NumberFormat`. Your branch and `main` now conflict in the same function,
and you'll hit that conflict again every time you test-merge or rebase. Time to teach Git to remember.

```
* chore(cart): note regional tax todo                  <- main
* refactor(price): use Intl.NumberFormat
| * docs: mention multi-currency prices                <- feature/multi-currency (HEAD)
| * feat(cart): add totalIn for multi-currency carts
| * feat(price): accept a currency code
|/
* chore: initial storefront
```

The correct resolution of `src/price.js` (agreed with Maya) is:

```js
// Price formatting
function formatPrice(cents, currency = 'USD') {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency }).format(cents / 100);
}

module.exports = { formatPrice };
```

## Your task

1. Turn on **rerere** ("reuse recorded resolution") for this repo.
2. Do a **trial merge**: merge `main` into `feature/multi-currency`, resolve `src/price.js` to exactly the code
   above, and commit the merge. (Git should say *Recorded resolution for 'src/price.js'*.)
3. Maya reviews and says: *"No merge commits in feature branches, please rebase instead."* Throw the merge
   commit away and **rebase** `feature/multi-currency` onto `main`. The same conflict comes back — let rerere
   resolve it for you, then finish the rebase.

When you're done:
- `feature/multi-currency` sits on top of `main` with its **3 original commits** (same messages, same order)
  and no merge commits.
- `src/price.js` on the branch is exactly the resolution above.
- `main` hasn't changed, nothing is in progress, and the working tree is clean.

## You'll practice

`rerere.enabled`, `git rerere status` / `git rerere diff`, trial merges, `git reset --hard ORIG_HEAD`, and
rebasing through a conflict that resolves itself.
