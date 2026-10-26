Run `git merge main`. When it stops, `git status` lists the file under *"Unmerged paths: both modified"*.
Nothing is broken: Git merged everything it could and left you this one decision.
---
Open `src/checkout.js`. Between `<<<<<<< HEAD` and `=======` is **your** side (the branch you're on);
between `=======` and `>>>>>>> main` is **their** side. Your job is to replace the whole block — markers
included — with the code you actually want.
---
Something like:

```js
// Apple Pay (SHOP-212) and gift cards (SHOP-215) accepted at checkout
const PAYMENT_METHODS = ['card', 'paypal', 'applepay', 'giftcard'];
```
---
Then `git add src/checkout.js` and `git commit` (or `git merge --continue`); keep the default message.
`git diff --check` warns if any markers are left. Made a mess? `git merge --abort` puts everything back to
before the merge.
