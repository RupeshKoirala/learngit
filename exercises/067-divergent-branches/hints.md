`git fetch` first, then compare: `git log --oneline --graph feature/reviews origin/feature/reviews` etc.
For `main` there's nothing to reconcile: `git switch main` + `git pull --ff-only` (or `git merge --ff-only origin/main`).
---
`feature/reviews`: your two commits exist only on your laptop, so rewriting them is harmless.
`git switch feature/reviews`, `git pull --rebase`, `git push`.
---
`release/2.5`: your commit is already *published* (the tag is on the server and QA built it). Rebasing would make a
**new** commit with a different hash, and the tag would point at a commit that isn't on the branch.
`git switch release/2.5`, `git pull --no-rebase` (a merge), `git push`. Don't push tags with it.
---
Config: `git config pull.rebase true` and `git config branch.release/2.5.rebase false`.
Per-branch settings win over `pull.rebase`. Check with `git config --local --list | grep rebase`.
