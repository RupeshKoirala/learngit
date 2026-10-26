# The three areas: split a pile of changes into logical commits

You spent the morning on **removeItem** for the cart. On the way you also spotted and fixed an unrelated
rounding bug in `formatPrice`. Now everything is mixed together — and out of habit you already ran
`git add` on two of the files.

Maya reviews commit by commit and wants one change per commit, so a bug fix can be reverted or
cherry-picked to a hotfix without dragging a half-reviewed feature along.

```
            working tree          staging area (index)        last commit
README.md   docs for removeItem   -                           Leave a TODO...
cart.js     removeItem            removeItem   (staged!)
price.js    rounding fix          rounding fix (staged!)
notes.txt   your scratch notes    -   (untracked)
```

## Your task

Make exactly **two new commits** on `main`:

1. `Fix rounding in formatPrice` — contains **only** `src/price.js`
2. `Add removeItem to cart` — contains `src/cart.js` **and** `README.md`

The order of the two commits doesn't matter. Rules:

- Don't edit the file contents — commit the changes as they are.
- `notes.txt` stays in the folder, **untracked** (not committed, not deleted).
- At the end nothing is staged and nothing else is modified.

## You'll practice

The working tree → staging area → commit model; `git status` (and `git status -s`), `git diff` vs
`git diff --staged`, `git restore --staged`, `git add <path>`, and `git show --stat` to verify a commit.
