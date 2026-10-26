List objects nothing points to: `git fsck --no-reflogs --unreachable` (or just `git fsck --lost-found`,
which writes the *dangling* ones to `.git/lost-found/`). You're interested in lines that say **commit**.
---
fsck only prints hashes. Show their subjects in one go:
`git log --no-walk --format='%h %s' $(git fsck --no-reflogs --unreachable | awk '/commit/ {print $3}')`
A stash commit's subject is `On <branch>: <your message>`; the helper commits are `index on main: …`.
---
Inspect your candidate before applying: `git stash show -p <hash>` (works on any stash-shaped commit) or
`git show <hash>`. You should see `expressCheckout` and `src/express.js`.
---
```bash
git stash apply <hash>
git status          # src/cart.js modified, src/express.js new
```
Want it back in the stash list instead? `git stash store -m "express checkout button" <hash>`.
