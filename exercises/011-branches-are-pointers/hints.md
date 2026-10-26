`git branch <name> <start-point>` creates a branch without switching to it. The start point can be anything
that names a commit: a branch, a tag, a hash, `HEAD~2`… Leave it out and Git uses `HEAD`.
Run `git log --oneline --graph --all --decorate` first so you can see every name.
---
- `git branch hotfix/1.0.1 v1.0`
- `git log --oneline` → copy the hash of `Add free-shipping threshold` → `git branch experiment/shipping-rules <hash>`
- Renaming is `git branch -m <old> <new>`.
---
`git switch -c feature/wishlist` creates **and** switches in one go (from `HEAD`, so be on `main` first,
or write `git switch -c feature/wishlist main`).
`git branch -vv` prints `[origin/xyz: behind N]` next to branches that are out of date.
---
Write the answer with `echo release/... > ../ANSWER` from inside `repo/` — use the exact name `git branch -vv`
showed as behind. Check yourself with `git log --oneline --graph --all --decorate`.
