`git reflog` lists every position `HEAD` has had, newest first: you'll see `reset: moving to HEAD`, then
`rebase (finish)`, `rebase (pick)`, `rebase (start)`, … The line *just below* `rebase (start)` is where you
were before the rebase. `git reflog show feature/returns` gives the same story for just the branch.
---
`ORIG_HEAD` is set by "dangerous" commands — rebase, reset, merge, am — to where you were before them. The
`git reset --hard` after the rebase overwrote it, so it now points at the bad result. The reflog keeps the
whole history (by default ~90 days), which is why it's the real safety net.
---
Verify before you act: `git log --oneline <hash>` should show all 3 of your commits, including the 30-day one.
Then: `git tag before-rebase <hash>` and `git reset --hard before-rebase` (you're on `feature/returns`).
You can also write the reflog entry directly, e.g. `git reset --hard feature/returns@{1}` (check `git reflog show feature/returns` first).
---
Now `git rebase main` again. At the README conflict, edit the end of the file to

```
Shipping: orders ship within 2 business days.

Returns: accepted within 30 days of delivery.
```

then `git add README.md` and `git rebase --continue`. Not `--skip`!
