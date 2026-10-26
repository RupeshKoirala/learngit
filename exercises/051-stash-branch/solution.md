# Solution

```bash
git stash list
git log -1 --oneline stash@{1}^1          # 2b2b2b2 Add checkout   <- where the stash was made
git stash show --stat stash@{1}           # src/checkout.js, src/loyalty.js

# (if you already tried `git stash apply` and got a conflict: git reset --hard — the stash is untouched)

git stash branch feature/loyalty-points stash@{1}
# Switched to a new branch 'feature/loyalty-points'
# Changes to be committed:   new file: src/loyalty.js
# Changes not staged:        modified: src/checkout.js
# Dropped stash@{1} (...)

git add -A
git commit -m "Add loyalty points to checkout"
git stash list                            # stash@{0}: On main: experiment: dark mode
git log --oneline --graph --all
```

**Why it works:** a stash entry is a commit whose **first parent is the `HEAD` you had when you stashed**
(its second parent records the index, and a third the untracked files if you used `-u`). `git stash
branch` checks out a new branch at that first parent, so the stash applies to the exact code it was
recorded against — conflicts are impossible. It even restores the staged/unstaged split (it applies with
`--index`), and drops the stash only after success.

Now the work is a normal commit on a normal branch: it can be pushed, reviewed, backed up, and
integrated with `git rebase main` (or a merge) — where you resolve the `checkout.js` conflict once, with
`git diff main...feature/loyalty-points` to see the full intent.

**Real-world notes**
- **Old stashes rot.** The longer a stash sits, the more `main` drifts and the harder `apply` gets. If
  work will outlive the day, commit it to a branch (and push it — stashes are local and die with your
  laptop). `git stash branch` is the rescue for when you didn't.
- A failed `git stash apply` never loses the stash — `apply` never drops, and `pop` only drops on success.
  `git reset --hard` (or `git checkout -- <files>`) gets you back to a clean state to try again.
- Housekeeping: review `git stash list` now and then. Anything older than a sprint is either a branch
  waiting to happen or garbage to `git stash drop`.
- When the rebase comes, `git config --global merge.conflictStyle zdiff3` shows the base version in the
  conflict markers, which makes three-week-old intent much easier to reconstruct.
