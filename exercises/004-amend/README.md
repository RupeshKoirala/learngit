# Fix your last commit: typo and forgotten file (amend)

You just committed the free-shipping banner. Two seconds later you notice:

```
* 9f3c2a1 Add free shiping banner      <- HEAD, main   (typo!)
* 4b7d0e8 Add removeItem to cart
* 1a2b3c4 Initial storefront
```

…and `git status` still shows `src/banner.css` as **untracked** — you forgot to add the stylesheet, so the
banner would ship unstyled. Nothing has been pushed yet.

## Your task

Fix the last commit instead of adding a "fix typo" / "forgot file" commit on top:

- The commit on top of `Add removeItem to cart` must be titled exactly `Add free shipping banner`.
- It must contain both `src/banner.js` **and** `src/banner.css`.
- `main` must still have exactly 3 commits, and the working tree must be clean.

## You'll practice

`git commit --amend` (with and without `--no-edit`), what "amend" really does (a *new* commit replaces the
old one), `git reflog`, and why you should never amend a commit others already pulled.
