Step one is always: give your commits a name so they can't get lost. A new branch created *here* points at
your last commit, so it already contains all three. `git switch -c feature/wishlist` does that **and** carries
your uncommitted edit along, because both branches point at the same commit.
---
Now `main` only needs to move. You're not on it, so you don't need to check it out: `git branch -f main <commit>`
moves a branch pointer directly. But to *what*? Your `origin/main` is only as fresh as your last fetch…
---
`git fetch` first. Then `git log --oneline --graph --all` shows a new commit on `origin/main`.
`git branch -f main origin/main` puts local main exactly there (and keeps its upstream setting).
---
Avoid `git reset --hard origin/main` while sitting on `main` with uncommitted changes — `--hard` throws the
`removeFromWishlist` edit away. If you prefer the reset route: `git stash`, `git reset --hard origin/main`,
`git switch feature/wishlist`, `git stash pop`.
