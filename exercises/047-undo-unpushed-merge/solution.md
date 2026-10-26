# Solution

```bash
git status                         # "You have unmerged paths" — a merge is in progress
git merge --abort                  # 1. back to HEAD (the search merge); README note survives
git log --oneline -1 ORIG_HEAD     #    Merge branch 'feature/search'  <- NOT what you want!
git log --oneline -1 HEAD~1        #    Round totals and prefix prices with US$ (= origin/main)
git reset --merge HEAD~1           # 2. undo the search merge, keep uncommitted edits
git status --short                 # 3.  M README.md
git log --oneline -1 origin/main   #    same as main
```

**Why it works:**
- `git merge --abort` = "reset to `HEAD` but try to keep pre-existing local changes". It drops the index
  entries for both the resolved (`price.js`) and conflicted (`cart.js`) files and removes `MERGE_HEAD`. Your
  README edit was in a file the merge didn't touch, so it stays.
- A merge commit's **first parent** is the branch you were on. So `HEAD~1` is exactly `main` before the
  merge. (`HEAD^2` would be the search branch tip.)
- `reset --merge <commit>` moves the branch and updates files that differ between `HEAD` and `<commit>`
  (here: deletes `src/search.js`), but refuses to touch — and keeps — files with uncommitted changes.
  `reset --hard` would have silently destroyed your README note.

**The `ORIG_HEAD` trap:** right after the *first* merge, `git reset --merge ORIG_HEAD` would have been the
textbook undo — `merge` saves the previous tip there. But starting the second merge overwrote `ORIG_HEAD`
with the then-current HEAD (the search merge), and aborting didn't change it back. So `ORIG_HEAD` now points
at where you already are. `ORIG_HEAD` only remembers the **last** dangerous operation — always check
`git log -1 ORIG_HEAD` before trusting it, or use the reflog / `origin/main`.

**Real-world notes**
- This only works because nothing was pushed. Once a merge is on a shared branch, revert it
  (`git revert -m 1`, exercise 039) instead.
- Merging feature branches into `main` locally is unusual on teams that use PRs — the PR merge button
  is where review, CI and branch protection apply. Keep local merges for your own branches.
- Before merging anything into `main`, commit or stash your notes. `git merge --abort` *usually* restores
  pre-existing changes, but Git's docs warn it can't always reconstruct them if they touch merged files.
- `git reset --keep` is another safe choice here: like `--merge`, it aborts instead of overwriting local
  changes. Make `--merge`/`--keep` your default and `--hard` the exception.
- Halfway through a resolution you actually want to *redo* one file? `git checkout -m src/cart.js`
  recreates the conflict markers for that file without aborting the whole merge.
