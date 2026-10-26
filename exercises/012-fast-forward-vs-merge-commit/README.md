# Fast-forward vs merge commit (and --ff-only)

Today you're the one merging approved work into `main` (Brightcart doesn't use GitHub's merge button for
this repo yet). The team's rules, from Maya's CONTRIBUTING notes:

- **Small fixes** go in as a **fast-forward** — no merge commit, history stays a straight line.
- **Features** always get a **merge commit** (`--no-ff`), even when a fast-forward would be possible, so the
  whole feature shows up as one unit you can find, review and revert in one step.
- Never create a merge "by accident": when you only expect a fast-forward, ask Git to refuse anything else.

```
* Document gift wrap                       <- feature/gift-wrap
* Add gift wrap pricing
* Round fractional cents before formatting  <- fix/price-rounding
* Add free-shipping threshold               <- main (HEAD)
| * Document loyalty points                 <- feature/loyalty-points
| * Add loyalty points calculation
|/
* Add removeItem to cart
* Initial storefront
```

## Your task

On `main`, in this order:

1. Merge `fix/price-rounding` as a **fast-forward** (no merge commit). Use `--ff-only` so Git would refuse if it
   couldn't fast-forward.
2. Merge `feature/gift-wrap` with a **real merge commit** (`--no-ff`) even though it could fast-forward.
3. Try `git merge --ff-only feature/loyalty-points`. It must **refuse**. Don't merge loyalty points at all
   (Dev will update his branch first). Find out *why* it refused: write the hash of the commit where
   `feature/loyalty-points` forked off `main` into `../ANSWER` (the file next to `repo/`).

End on `main` with a clean working tree and no merge in progress. Don't change the three branches themselves.

## You'll practice

`git merge --ff-only`, `git merge --no-ff`, `git merge-base`, reading `git log --graph`, and the rule
"a fast-forward is only possible when the target is an ancestor of the branch".
