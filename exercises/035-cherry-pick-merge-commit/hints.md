Find the merge: `git log --oneline --merges main`. A merge commit `M` has two parents: `M^1` (what `main`
was before) and `M^2` (the tip of `lena/wishlist`). `git diff M^1 M --stat` shows what the merge brought into
`main` — that's exactly the change you want.
---
`git cherry-pick -m 1 M` means "replay the diff between M's **first** parent and M". Parent 1 is the branch
you merged *into* (the mainline), so that diff is the feature. The result is an ordinary single-parent commit.
---
Add `-x` for the traceability line and `-e` to edit the message before committing (or fix the message
afterwards with `git commit --amend`, keeping the `(cherry picked from …)` line):
```bash
git switch release/2.4
git cherry-pick -x -m 1 -e <merge-hash>
```
---
Change the first line of the message to `Add wishlist (backport of PR #42)`, keep the `cherry picked from`
line, save. Verify: `git log -1` and `git show --stat` (wishlist files only, no `recommend.js`).
