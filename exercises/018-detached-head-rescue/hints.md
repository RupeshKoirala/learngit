The commits exist, but no branch or tag points at them, so `git log --all` can't reach them. Something *did*
record them, though: every time `HEAD` moves, Git writes a line in the **reflog**. Run `git reflog`.
---
Read the reflog from the top (newest) down. You're looking for the entry
`commit: Fix coupon expiry off-by-one`. Ignore `debug: log every cart change` — that's the old experiment.
`git log -g --oneline` shows the same list; `git show <hash>` lets you peek at a commit.
---
A branch is just a name for a commit. Give the lost commit a name:
`git branch hotfix/1.2.1 <hash of Fix coupon expiry off-by-one>` — its parent (the test commit) and v1.2
come along automatically, because a branch contains every commit reachable from its tip.
---
Verify: `git log --oneline v1.2..hotfix/1.2.1` must show exactly the two commits. You can also find it with
`git reflog | grep 'Fix coupon'`, or reference reflog entries directly like `HEAD@{5}`.
