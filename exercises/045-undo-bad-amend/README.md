# Undo a commit --amend that swallowed the wrong changes

On `feature/order-emails` you committed "Add order confirmation email". Then you fixed an unrelated
rounding bug in `src/price.js`, staged it, and — muscle memory — typed `git commit --amend --no-edit`
instead of a new commit.

```
before the amend                          now
* Add order confirmation email            * Add order confirmation email   <- feature/order-emails
  (src/email.js)                            (src/email.js + src/price.js!)
* Initial storefront   <- main            * Initial storefront              <- main
```

The rounding fix is now hidden inside the email commit. Maya wants them as separate commits so the fix can
be cherry-picked to the release branch on its own. Nothing is pushed yet.

## Your task

Make `feature/order-emails` have exactly **two** commits on top of `main`:

1. `Add order confirmation email` — only `src/email.js`, exactly as it was **before** the amend
2. `Fix price rounding` — only the `src/price.js` change

The final code must be identical to what you have now, `main` must not change, and the working tree must be
clean.

## You'll practice

What `--amend` really does (it *replaces* the commit), `HEAD@{1}` in the reflog, and `git reset --soft`
to "un-amend" while keeping your staged changes.
