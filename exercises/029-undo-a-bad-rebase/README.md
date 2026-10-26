# Undo a bad rebase with the reflog

Last night, tired, you rebased `feature/returns` onto `main`. It stopped with a conflict in `README.md`
(Lena had documented shipping times at the very spot where you documented returns). You panicked, typed
`git rebase --skip`, it finished, and you ran `git reset --hard` "to be safe". Then you went to bed.

This morning Sam asks why the PR says returns are accepted within **14** days. Here's your branch now:

```
* Charge a restocking fee for opened items   <- feature/returns
* Add returns policy module
* Document shipping times                    <- main
* Initial storefront
```

`Extend the return window to 30 days` is gone — `--skip` dropped the *whole commit*, code and docs, not just the
conflicting part. Don't rewrite it from memory: Git still has every commit you ever made.

## Your task

1. Find the commit `feature/returns` pointed at **before** the rebase and tag it `before-rebase` (a backup
   you can always return to). Careful: `ORIG_HEAD` won't help you this time — find out why.
2. Put `feature/returns` back to that commit, and **redo the rebase properly**: when the `README.md` conflict
   appears, keep **both** lines (Lena's shipping line first, then your returns line).

Done means: tag `before-rebase` = your original pre-rebase tip; `feature/returns` = `main` + 3 commits with the
original messages in order; `RETURN_WINDOW_DAYS = 30`; README has both lines and no conflict markers;
`src/fees.js` unchanged; `main` unchanged; clean tree, no rebase in progress.

## You'll practice

`git reflog` and `git reflog show <branch>`, `branch@{n}` syntax, what `ORIG_HEAD` is (and what overwrites it),
`git reset --hard <commit>` to restore a branch, and backup tags before risky history edits.
