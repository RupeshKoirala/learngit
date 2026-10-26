Start with `git log --oneline main..HEAD` to see exactly which commits belong to your branch, then run
`git rebase -i main`. Git opens a todo list in your editor, oldest commit first.
---
In the todo list, the lines are commands. `pick` keeps a commit, `fixup` (or `f`) melts a commit into the one
above it and throws its message away, `squash` (`s`) does the same but lets you edit the combined message,
`reword` (`r`) keeps the change but lets you rename it. You can also **move lines** to reorder commits.
---
Move the `Document discount codes` line to the bottom. Keep the first `wip` as `reword` (or `pick` and fix the
message later), and mark every other code commit as `fixup`:

```
reword <hash> wip
fixup  <hash> wip 2
fixup  <hash> fix rounding lol
fixup  <hash> oops forgot export? no. debug line
fixup  <hash> remove debug
pick   <hash> Document discount codes
```
Save, then type the new message `Add discount code support` when Git asks.
---
Messed up? `git rebase --abort` while it's running, or afterwards `git reset --hard ORIG_HEAD`
(or find the old tip in `git reflog`) and try again.
