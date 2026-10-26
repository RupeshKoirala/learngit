The rejection is Git protecting Dev's commit: a normal push only succeeds if it **fast-forwards** the remote
branch. Yours doesn't, because the remote has a commit you don't. You need that commit locally first.
---
`git pull` = `git fetch` + integrate. The integrate step is either a merge (creates a merge commit) or a
rebase (replays your commits on top). The team wants linear history, so you want the rebase flavour.
---
`git pull --rebase` (or `git fetch` then `git rebase origin/main`). Then `git log --oneline --graph -5` should
show your two commits sitting on top of Dev's, and `git push` will be a fast-forward.
---
Accidentally created a merge commit with a plain `git pull`? Before pushing, undo it with
`git reset --hard ORIG_HEAD` (or `git reset --hard main@{1}`), then `git pull --rebase`.
