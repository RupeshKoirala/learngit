`git remote add upstream ../remotes/brightcart.git` (the path is relative to `repo/`), then `git fetch upstream`.
`git remote -v` should now list both `origin` (your fork) and `upstream`, and `git branch -r` shows `upstream/main`.
---
Syncing the fork is three commands: `git switch main`, `git merge --ff-only upstream/main`, `git push origin main`.
(On GitHub the "Sync fork" button does the same for the fork's main on the server.)
---
`git switch feature/size-guide` then `git rebase upstream/main`. Check `git log --oneline upstream/main..HEAD`
shows 2 commits. The fork still has the pre-rebase version, so a normal push is rejected.
---
`git push --force-with-lease` (the branch's upstream is `origin/feature/size-guide`, i.e. your fork).
It's your own PR branch, so rewriting it is fine; the PR updates automatically.
