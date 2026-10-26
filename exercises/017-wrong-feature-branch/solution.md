# Solution

```bash
git log --oneline -4
# 9d8c7b6 (HEAD -> feature/search-filters) Show wishlist count badge
# 5a4b3c2 Add wishlist heart button
# 1f2e3d4 Add brand filter
# 0a9b8c7 Add price range filter

# 1. copy the two commits to the right branch
git switch feature/wishlist
git cherry-pick feature/search-filters~2..feature/search-filters

# 2. remove them from the wrong branch
git switch feature/search-filters
git reset --hard HEAD~2                 # back to 'Add brand filter'

git log --oneline --graph --all
```

Alternative in one command (moves the commits instead of copying them):

```bash
git rebase --onto feature/wishlist feature/search-filters~2 feature/search-filters
# now feature/search-filters has the wishlist commits on top of wishlist... so:
git branch -f feature/wishlist feature/search-filters
git branch -f feature/search-filters <hash of Add brand filter>     # from git reflog
```
(More steps to get right — cherry-pick + reset is the everyday tool.)

**Why it works:** `cherry-pick A..B` takes each commit in the range, computes its diff against its parent, and
applies that diff as a **new** commit (same message, same author, new hash) on top of `HEAD`. Because the
wishlist commits only touch `src/wishlist-button.js`, they apply cleanly on `feature/wishlist`. Then
`reset --hard HEAD~2` moves the search branch pointer back two commits. The old commits aren't deleted — they're
just unreferenced, and the reflog keeps them for ~90 days.

**Real-world notes**
- Copy first, delete second. If anything goes wrong in between, nothing is lost.
- If you'd already **pushed** `feature/search-filters`, the reset rewrites published history: follow with
  `git push --force-with-lease` — OK on your own feature branch, but tell reviewers so nobody builds on the old
  version. Never do this to `main`.
- Cherry-picked commits have new hashes. If both the original and the copy end up merged somewhere, Git usually
  copes (same patch), but it's a smell — make sure the originals are really gone from the wrong branch.
- `git cherry-pick -x` adds "(cherry picked from commit …)" to the message — useful for backports to release
  branches, noise for a fix-up like this one.
- Prevention: one worktree per ticket (`git worktree add ../shop-wishlist feature/wishlist`) means you can't
  be "on the wrong branch" in a folder — each folder *is* a branch.
