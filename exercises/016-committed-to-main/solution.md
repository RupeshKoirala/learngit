# Solution

```bash
git status                           # On branch main, src/wishlist.js modified
git switch -c feature/wishlist       # name the commits; the uncommitted edit comes along
git fetch                            # learn where main really is now
git log --oneline --graph --all
# * 7d1e2f3 (origin/main) Round fractional cents in formatPrice      <- Dev's push
# | * 4c5d6e7 (HEAD -> feature/wishlist, main) Add wishlist tests
# | * ...
# |/
# * 1a2b3c4 Add removeItem to cart
git branch -f main origin/main       # move main without checking it out
git status                           # On branch feature/wishlist, src/wishlist.js still modified
git branch -vv                       # main [origin/main] — up to date, upstream kept
```

**Why it works:** your three commits never belonged to `main` in any deep sense — `main` was just the name
pointing at them. Creating `feature/wishlist` at the same commit gives them a second name; then moving `main`
back removes the first. No commit is copied or rewritten, so the hashes stay the same. Switching to a branch
that points at the *same commit* never touches your working tree, which is why the uncommitted edit survives.
`git branch -f` moves a pointer you're not standing on, so it can't touch your files at all.

The trap: `git reset --hard origin/main` on `main` would also work for the commits (they're safe on
`feature/wishlist`), but `--hard` resets the working tree too and would silently delete your uncommitted
`removeFromWishlist`. And without `git fetch`, `origin/main` is the *old* position — you'd have to fix main again.

**Real-world notes**
- Recovery order for any "oops": **1. name it** (branch/tag), **2. move pointers**, **3. clean up**. Once a
  commit has a name you can't lose it.
- `git reset --keep` is the safer cousin of `--hard`: it refuses if it would overwrite local changes.
- Next you'd probably update the feature: `git rebase origin/main` (or merge) so your PR is based on Dev's fix.
- If you *had* pushed to `main` (unprotected repo), don't force-push a shared branch. Revert instead, or
  coordinate with the team — others may already have pulled those commits.
- Prevention: protect `main` on GitHub (require PRs), and show the branch in your prompt
  (`__git_ps1`, starship, oh-my-zsh). Some teams add a `pre-commit` hook that refuses commits on `main`.
