Step 1: `git branch flat/promo-banner` (creates it here), then `git rebase main flat/promo-banner` — that
switches to it and rebases it. Compare `git log --oneline --graph main..flat/promo-banner` with the feature
branch: the merge commit is gone.
---
Step 2: `git switch feature/promo-banner`. The option you want is `--rebase-merges` (short: `-r`). It rebuilds
the branch's commit *graph* on the new base, merges included, instead of a straight line.
---
`git rebase -r main`. Curious how it works? Run `git rebase -i -r main` once (save without changes): the todo
list uses `label` to name points in the graph, `reset` to jump back to one, and `merge -C <hash> <label>` to
recreate the merge with its original message.
---
Check both with `./lg graph`, then `git diff flat/promo-banner feature/promo-banner` (empty) and
`git log --merges --oneline main..feature/promo-banner` (one merge). Went wrong? `git reset --hard ORIG_HEAD`.
