# Shared Git hooks: block secrets, enforce Conventional Commits

Last week a live Stripe key sat in `src/payments.js` for 40 minutes before anyone noticed
(see `docs/incident-2025-01.md`). The same week, Sam (PM) asked why the release notes generator
skipped half the changes: people keep writing messages like `fixed stuff`.

Maya (tech lead) gives you the action item: **ship Git hooks that every developer gets from the repo
itself**. Hooks in `.git/hooks/` are never committed or cloned, so you'll put them in a versioned
`.githooks/` folder and point Git at it with `core.hooksPath`.

```
* docs: adopt Conventional Commits        <- main
* docs: write up the leaked-key incident
* feat(checkout): add payment client
* feat(price): add formatDiscount helper
* chore: initial storefront
```

## Your task

In `repo`:

1. Create **`.githooks/pre-commit`** that rejects the commit (exits non-zero with a helpful message) when
   the lines **being added** by the commit contain any of:
   - `console.log(`
   - a Stripe live key: `sk_live_` followed by letters/digits
   - a private key header: `-----BEGIN … PRIVATE KEY-----`

   Only look at **added lines of the staged diff**, not whole files: `scripts/seed.js` is a CLI script that
   legitimately prints with `console.log`, and editing (or deleting) other lines of it must still work.
2. Create **`.githooks/commit-msg`** that rejects a message whose first line is not
   [Conventional Commits](https://www.conventionalcommits.org): `type(optional-scope)!: description`, where
   type is one of `feat fix docs style refactor perf test build ci chore revert`. Examples that must pass:
   `feat(cart): add bulk discount`, `fix!: drop legacy coupon codes`, `docs: explain hooks`.
   Git's own merge messages (`Merge branch '…'`) must also pass.
3. Make both hooks **executable**, point this repo at the folder with `core.hooksPath`, and **commit** the
   `.githooks/` folder with a Conventional Commits message (your hook will be watching!).
4. Leave the working tree clean.

`./lg check` clones your repo and really tries a dozen good and bad commits against your hooks.

## You'll practice

`core.hooksPath`, the `pre-commit` and `commit-msg` hooks, `git diff --cached`, exit codes as a gate,
file modes in Git (`100755`), and why hooks are a convenience, not a security boundary.
