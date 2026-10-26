Step 1 has a dedicated command: `git merge --abort`. It puts the index and the conflicted files back to
`HEAD` (the search merge) — and leaves changes in files the merge never touched, like your README, alone.
---
Now `main` points at the search merge commit. Its **first parent** (`HEAD~1` or `HEAD^1`) is where `main` was
before you merged — the same commit as `origin/main`. Its second parent (`HEAD^2`) is the search branch tip.
Check: `git log --oneline -1 HEAD~1` and `git log --oneline -1 origin/main`.
---
`git reset --hard HEAD~1` would work *and wipe your README note*. `git reset --merge HEAD~1` (or `--keep`)
moves `main` back and updates only files that differ between the two commits, keeping your uncommitted
edits in other files.
---
Why not `ORIG_HEAD`? Starting the second merge saved the then-current HEAD — the search merge — into
`ORIG_HEAD`. So `git reset --merge ORIG_HEAD` resets to where you already are. Solution:
```bash
git merge --abort
git reset --merge HEAD~1        # or: git reset --merge origin/main
git status --short              #  M README.md
```
