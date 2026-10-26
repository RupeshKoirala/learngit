# Main moved: resolve a pull request conflict

You built **`feature/sale-banner`**. Meanwhile Dev's urgent **`hotfix/round-totals`** goes in first. Both
of you added a line at the top of the `## Unreleased` section of `CHANGELOG.md` - the most common conflict
in real life.

```
          o  Add sale banner              <- feature/sale-banner (yours)
         /
...--o--o                                 <- main
         \
          o  Round totals to whole cents  <- hotfix/round-totals (Dev)
```

## Your task

1. Open a PR for `hotfix/round-totals` and **merge it** (any allowed method). `main` has moved.
2. Open a PR for `feature/sale-banner`. GitHub now says *"This branch has conflicts that must be resolved"*.
3. Resolve it **locally**: bring the new `main` into your branch (`git rebase origin/main` **or**
   `git merge origin/main`), keep **both** changelog lines, finish the operation, run `./test.sh`, and push
   (a rebased branch needs `--force-with-lease`).
4. The PR must become mergeable - then **merge it**.

## You'll practice

`gh pr view` / `gh pr checks` mergeability, `git fetch`, `git rebase origin/main` vs `git merge origin/main`
on a PR branch, conflict markers, `git push --force-with-lease`, and GitHub's web conflict editor.
