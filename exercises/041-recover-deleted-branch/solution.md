# Solution

```bash
git reflog
# 1a2b3c4 HEAD@{0}: checkout: moving from feature/old-banner to main
# 1a2b3c4 HEAD@{1}: checkout: moving from main to feature/old-banner
# 1a2b3c4 HEAD@{2}: checkout: moving from spike/try-new-router to main
# 5d6e7f8 HEAD@{3}: commit: Spike: new router
# 1a2b3c4 HEAD@{4}: checkout: moving from main to spike/try-new-router
# 1a2b3c4 HEAD@{5}: commit: Add currency TODO
# 9a8b7c6 HEAD@{6}: checkout: moving from feature/wishlist to main
# e1f2a3b HEAD@{7}: commit: Document the wishlist            <- last commit on the branch
# ...

git show --stat e1f2a3b                    # yep, the wishlist README change
git branch feature/wishlist e1f2a3b         # or: git branch feature/wishlist 'HEAD@{7}'
git log --oneline main..feature/wishlist   # 3 commits — they're back
```

**Why it works:** a branch is a 41-byte file holding a commit hash. `git branch -D` deletes that file (and
the branch's *own* reflog) but not the commits. Those stay in the object database, and HEAD's reflog still
lists every commit HEAD pointed at — including the last one you made on the branch. Pointing a new branch
at it restores everything, including all its ancestors.

**Real-world notes**
- The reflog is **local** and **private**: it lives only in your `.git`, isn't pushed and isn't shared. A
  teammate's deleted branch must be recovered from *their* reflog (or from the remote, or a PR on GitHub,
  which keeps a "Restore branch" button after merge/delete).
- Unreachable commits survive at least until `git gc` prunes them — by default reflog entries for
  unreachable commits expire after **30 days** (`gc.reflogExpireUnreachable`), reachable ones after 90. So
  you have weeks, not forever.
- Didn't you ever check the branch out (e.g. you created it with a script)? Then it's not in HEAD's reflog;
  use `git fsck --lost-found` / `git fsck --unreachable | grep commit` to find dangling commits (exercise 043).
- Prefer `git branch -d` (lower-case): it refuses to delete unmerged branches. `-D` is "I know what I'm
  doing". `git branch --merged main` lists the ones that are safe to clean up.
- The cheapest insurance: push your WIP branches. A branch on the remote is a backup nobody has to dig for.
