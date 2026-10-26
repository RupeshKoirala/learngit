# Solution

```bash
git switch feature/gift-cards
git merge main
# Auto-merging src/checkout.js
# CONFLICT (content): Merge conflict in src/checkout.js
# Automatic merge failed; fix conflicts and then commit the result.
git status          # src/applepay.js is already staged; src/checkout.js is "both modified"
```

The file now contains:

```js
// Checkout configuration
<<<<<<< HEAD
// Gift cards accepted at checkout (SHOP-215)
const PAYMENT_METHODS = ['card', 'paypal', 'giftcard'];
=======
// Apple Pay enabled for iOS users (SHOP-212)
const PAYMENT_METHODS = ['card', 'paypal', 'applepay'];
>>>>>>> main
const CHECKOUT_BANNER = 'Free shipping on orders over $50';
```

Replace the whole block (markers too) with the combined intent:

```js
// Checkout configuration
// Payment methods: Apple Pay (SHOP-212), gift cards (SHOP-215)
const PAYMENT_METHODS = ['card', 'paypal', 'applepay', 'giftcard'];
const CHECKOUT_BANNER = 'Free shipping on orders over $50';
```

```bash
git diff --check                  # no output = no leftover markers
git add src/checkout.js
git commit                        # or: git merge --continue   (keep "Merge branch 'main' into feature/gift-cards")
git log --oneline --graph
```

**Why it works:** Git merges line by line against the common ancestor (`Initial storefront`). Lines only one
side changed are taken automatically; lines **both** sides changed differently become a conflict. Git can't know
that "add applepay" and "add giftcard" are compatible — that's a human decision. `git add` tells Git "this file
is resolved", and the commit records a merge with two parents: your old tip and `main`.

**Real-world notes**
- *Keep both intents* is the default answer, but never blindly. Ask: does the combination still make sense?
  Here: does the payment provider support gift cards + Apple Pay together? If unsure, ask the other author —
  a 2-minute Slack message beats a production bug.
- Run the tests after resolving, before committing. A conflict-free merge can still be broken
  (e.g. one side renamed a function the other side calls).
- Merging `main` into your branch vs rebasing your branch onto `main`: both resolve the same conflict. Merging
  keeps history honest and is safe on shared branches; rebasing gives a linear history (module 03).
- GitHub's web conflict editor works for simple cases like this, but it creates the same merge commit — doing
  it locally lets you run tests first.
- `git log --merge -p src/checkout.js` during a conflict shows only the commits from both sides that touched the
  file — very handy to understand *why* each side changed it.
