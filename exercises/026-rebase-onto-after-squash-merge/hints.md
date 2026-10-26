`git log --oneline main..feature/search-ui` lists 5 commits — that's what a plain `git rebase main` would
replay. Which range contains *only your* two commits? Try `git log --oneline feature/search-api..feature/search-ui`.
---
`git rebase --onto <newbase> <upstream>` takes the commits in `<upstream>..HEAD` and replays them on top of
`<newbase>`, ignoring everything at or below `<upstream>`. Here: newbase = `main`, upstream = the last
commit that is not yours.
---
`git rebase --onto main feature/search-api` (while on `feature/search-ui`), or in one go:
`git rebase --onto main feature/search-api feature/search-ui`.
---
If Dev's branch had already been deleted, use the hash of his last commit (`git log` shows it, it's the parent
of your first commit: `<your-first-commit>^`), or count: `git rebase --onto main HEAD~2`.
