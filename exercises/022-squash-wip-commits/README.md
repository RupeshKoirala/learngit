# Squash your messy WIP commits before review

You've been hacking on `feature/discount-codes` all afternoon. It works, but the history is embarrassing:

```
* remove debug
* oops forgot export? no. debug line
* Document discount codes
* fix rounding lol
* wip 2
* wip
* Add removeItem to cart        <- main
```

Maya (tech lead) reviews commit by commit. Before you open the pull request, clean the branch up with an
**interactive rebase** so it tells a clear story.

## Your task

On `feature/discount-codes`, rewrite the 6 commits on top of `main` into exactly **2 commits**:

1. `Add discount code support` — all the code changes to `src/discount.js`
2. `Document discount codes` — the README change

Rules:
- The final files must be exactly what you have now (don't lose or change any code).
- `main` must not change.
- Leave the working tree clean (no rebase in progress).

## You'll practice

`git rebase -i`, the `pick / squash / fixup / reword / drop` commands, reordering lines in the todo list,
and `git log --oneline main..HEAD` to see what you're about to rewrite.
