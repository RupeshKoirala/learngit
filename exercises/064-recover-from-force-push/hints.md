`git reflog show release/2.4` lists every position the branch has had, newest first. The entry just before
"reset: moving to origin/release/2.4" is your old tip. You can name it `release/2.4@{1}`.
`git log --oneline release/2.4@{1}` should show your two commits.
---
You want the commits that are in your old tip but not in the current branch:
`git log --oneline HEAD..release/2.4@{1}`. Those two need to be re-applied on top of Dev's work.
---
`git cherry-pick HEAD..release/2.4@{1}` (or cherry-pick the two hashes, oldest first). Then a normal `git push` —
it's a fast-forward of Dev's commits, so no force is needed (and none is allowed).
---
Server side: `git --git-dir=../remotes/origin.git config receive.denyNonFastForwards true`.
On GitHub that's a branch protection rule / ruleset with "Block force pushes".
