# Your first merge conflict: keep both intents

You opened a pull request for **gift cards** (`feature/gift-cards`). GitHub says:
*"This branch has conflicts that must be resolved."* Lena's **Apple Pay** PR was merged into `main` an hour
ago, and you both edited the same two lines of `src/checkout.js`:

```
* Enable Apple Pay at checkout       <- main      (Lena)
* Add Apple Pay session helper
| * Accept gift cards at checkout    <- feature/gift-cards (HEAD, you)
| * Add gift card balance lookup
|/
* Initial storefront
```

```js
// Lena's version (main)                          // your version
// Apple Pay enabled for iOS users (SHOP-212)     // Gift cards accepted at checkout (SHOP-215)
const PAYMENT_METHODS = ['card', 'paypal',        const PAYMENT_METHODS = ['card', 'paypal',
                         'applepay'];                                      'giftcard'];
```

Neither of you is "right". The shop must accept **both** Apple Pay and gift cards.

## Your task

On `feature/gift-cards`:

1. Merge `main` into your branch. It will stop with a conflict in `src/checkout.js`.
2. Resolve it so that `PAYMENT_METHODS` contains **all four** methods — `card`, `paypal`, `applepay`,
   `giftcard` — declared exactly once. Keep a comment that mentions both tickets if you like.
3. Remove every conflict marker, stage the file and **finish the merge** (a merge commit on your branch).

`main` must not change. Both new files (`src/giftcard.js`, `src/applepay.js`) must be in the result.
End with a clean working tree and no merge in progress.

## You'll practice

Reading `git status` during a merge, the `<<<<<<<` / `=======` / `>>>>>>>` markers, deciding what the
combined code should be, `git add` to mark a file resolved, and `git commit` / `git merge --continue`.
