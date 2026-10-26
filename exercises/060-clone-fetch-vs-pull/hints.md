Cloning is run from the sandbox folder, not from inside `repo`: `cd ..` then `git clone <path-to-bare-repo> fresh`.
In `repo`, `git fetch` updates `origin/*` (your view of the remote) and never touches your own branches or files.
---
After fetching, `git status` on `main` says "Your branch is behind 'origin/main' by N commits". Two other ways
to see it: `git log --oneline main..origin/main` (what you'd receive) and `git rev-list --count main..origin/main`.
---
`git merge --ff-only origin/main` moves `main` forward if (and only if) that's possible without a merge
commit. If you had local commits it would refuse instead of surprising you — that's the point.
---
`git switch feature/gift-cards` — when no local branch has that name but `origin/feature/gift-cards` exists,
Git creates a local branch that tracks it. Check with `git branch -vv`. Then `git switch main`.
