First get the latest state of origin without touching your branch: `git fetch`. Then compare:
`git log --oneline --graph main origin/main`. Which commits are *only* yours? `git log --oneline --no-merges origin/main..main`.
---
A plain `git rebase <upstream>` replays the non-merge commits that aren't in `<upstream>` and **drops merge
commits** (unless you ask for `--rebase-merges`). The teammates' commits that came in via your merges are already in
`origin/main`, so they're skipped too.
---
```bash
git fetch
git rebase origin/main
git log --oneline --graph -6
```
---
Then `git push` (no force needed: your new `main` is a fast-forward of `origin/main`) and
`git config pull.rebase true`.
