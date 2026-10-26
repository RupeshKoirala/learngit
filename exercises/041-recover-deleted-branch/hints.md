Every time HEAD moves (commit, switch, reset, merge…), Git writes a line to the **reflog**. Run `git reflog`
and look for the moment you left the wishlist branch: `checkout: moving from feature/wishlist to main`.
---
The entry *just before* that line (one row **lower** in the list — the reflog is newest first) is the last
commit you made on `feature/wishlist`. `git log -g --oneline` shows the same list with commit subjects, and
`git show <hash>` lets you confirm it's "Document the wishlist".
---
A branch is just a name for a commit, so recreating it is one command:
`git branch feature/wishlist <hash>` (or `git switch -c feature/wishlist <hash>`).
---
Verify: `git log --oneline main..feature/wishlist` should list exactly the 3 wishlist commits. A shortcut
for the hash: `git reflog | grep 'moving from feature/wishlist'` and use the `HEAD@{n}` *before* it, e.g.
`git branch feature/wishlist 'HEAD@{7}'` (quote it in zsh).
