# rebase --onto: move only your commits after a squash-merge

Dev's search API wasn't merged yet, so you branched `feature/search-ui` off **his** branch. This morning Maya
landed his PR with GitHub's **Squash and merge** — his three commits became one brand-new commit on `main`:

```
* Add support email to README          <- main
* Add product search API (#42)         (Dev's 3 commits squashed into one NEW commit)
| * Debounce search box input          <- feature/search-ui (you)
| * Add search box component
| * Limit search results to 20         <- feature/search-api (Dev, already merged as #42)
| * Make search case-insensitive
| * Add basic product search
|/
* Initial storefront
```

Git doesn't know that #42 "is" Dev's three commits. Try `git rebase main` if you like (then `git rebase --abort`):
Git tries to replay Dev's old commits too, and they conflict with their own squashed version.

## Your task

Move **only your two commits** onto the current `main`:

- `feature/search-ui` = `main` + exactly `Add search box component`, `Debounce search box input` (in that order).
- None of Dev's old commits are on your branch any more; compared to `main` your branch only adds
  `src/search-ui.js`, exactly as you wrote it.
- `main` doesn't change. Clean tree, no rebase in progress.

## You'll practice

`git rebase --onto <newbase> <upstream> <branch>`, thinking of a rebase as "take the commits in
`upstream..branch` and put them on `newbase`", and why squash-merges confuse plain rebases.
