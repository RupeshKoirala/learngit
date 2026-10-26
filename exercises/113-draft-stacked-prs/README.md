# Draft & stacked PRs

Sales tax is a two-part job: (1) the calculation, (2) showing it in prices. Part 2 needs part 1, but you
don't want one giant PR - reviewers would drown. So you **stack** them: PR 2's base is PR 1's branch. And you
open PR 1 as a **draft** first, to get early feedback on the approach without anyone merging it.

```
main ── A  stack/1-tax-calc      PR 1: base main              (draft -> ready -> merged)
           └── B  stack/2-tax-display   PR 2: base stack/1-tax-calc  (-> retargeted to main)
```

The catch: when PR 1 is **squash-merged**, `main` gets a *new* commit A'. PR 2 still contains the original A,
so it suddenly shows A again (or conflicts). You fix that by rebasing B onto `main` and dropping A.

## Your task

1. Branch **`stack/1-tax-calc`** from `main`: add `src/tax.js` (e.g. `addTax(cents, rate)`), **one commit**,
   push, and open a **draft** PR into `main`.
2. Branch **`stack/2-tax-display`** from `stack/1-tax-calc`: use `addTax` somewhere (e.g. a new
   `src/price-with-tax.js`), **one commit**, push, and open PR 2 with **base `stack/1-tax-calc`**.
3. Mark PR 1 **ready for review** and **merge it** (squash, if that's your repo's policy).
4. Make PR 2 target **`main`** (GitHub may retarget it automatically when the base branch is deleted) and
   **rebase** it so it no longer contains PR 1's original commit; push with `--force-with-lease`.
   PR 2 must be mergeable. Merging it is optional.

## You'll practice

`gh pr create --draft`, `gh pr ready`, `gh pr create --base <branch>`, `gh pr edit --base main`,
`git rebase --onto`, `git push --force-with-lease`, why squash + stacks need care.
