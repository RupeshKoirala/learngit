# Fix review feedback with fixup! commits and --autosquash

Maya reviewed your PR `feature/gift-cards` and left two comments:

> **src/giftcard.js** — `{61}`? Codes are 16 characters. This rejects every real card.
>
> **src/checkout.js** — the TODO is the bug: you can redeem $500 from a $5 card. Throw if the balance is too low.

```
* Document gift cards               <- feature/gift-cards
* Redeem gift cards at checkout     (src/checkout.js)
* Add gift card model               (src/giftcard.js)
* Initial storefront                <- main
```

You've already made both fixes in your working tree (`git diff`), but haven't committed them. The team's
convention: **each fix goes into the commit it belongs to** — no "address review comments" commit at the end —
so the history stays as three clean, reviewable commits.

## Your task

1. Commit each fix as a **fixup commit** that targets the right original commit.
2. Fold them in with an autosquash rebase.
3. Make autosquash the default *for this repository* (`rebase.autoSquash`), so future `git rebase -i` runs do
   it automatically. (Set it with plain `git config` inside the repo so the checker can see it — put it in your
   `--global` config afterwards if you like it.)

Done means: exactly 3 commits on top of `main`, same messages as before; `Add gift card model` itself contains
the `{16}` fix and only touches `src/giftcard.js`; `Redeem gift cards at checkout` itself contains the balance
check and only touches `src/checkout.js`; no `fixup!` commits left; final files = your fixed working tree;
clean tree.

## You'll practice

`git commit --fixup <commit>`, `git rebase -i --autosquash`, the `rebase.autoSquash` setting, and finding a
commit hash with `git log --oneline` / `:/message` syntax.
