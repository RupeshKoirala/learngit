After a rebase the branch on origin is not an ancestor of yours, so a normal push would *drop* commits on the
server — Git rejects it. `git push --force-with-lease` overwrites the branch **only if** it is still where
your `origin/feature/order-notes` says it is (i.e. nobody pushed since you last fetched).
---
Step 3: `git commit --amend -m "Add order note length limit"`, then `git push --force-with-lease`. It fails with
`! [rejected] ... (stale info)`: origin moved (Maya) since your last fetch. A plain `--force` here would have
silently deleted her fix.
---
`git fetch`, then `git log --oneline HEAD..origin/feature/order-notes` shows what's on the server that you don't
have: Maya's commit (and the old copy of your typo commit, which you've replaced). You only want *her* commit.
---
`git cherry-pick <hash-of-Maya's-commit>` (here simply `git cherry-pick origin/feature/order-notes`, since it's
the tip), check `git log --oneline origin/main..HEAD` shows 4 commits, then `git push --force-with-lease`.
(`git pull --rebase` would quietly drop your amended commit as "already applied" and keep the typo.)
