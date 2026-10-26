You're on `feature/search`, and Git won't delete the branch you're standing on. `git switch main` first.
Then compare `git branch --merged main` with `git branch --no-merged main`.
---
`git branch -d feature/search fix/typo-footer feature/old-promo-banner` — `-d` only deletes if the branch is
fully merged, so it's a safety net. Try `git branch -d spike/graphql-experiment`: it refuses. That refusal is
the point. Since the team decided to drop it, `git branch -D spike/graphql-experiment`.
---
Deleting locally doesn't touch GitHub: `git push origin --delete feature/search fix/typo-footer`.
`git branch -r` lists your remote-tracking refs; `origin/feature/old-promo-banner` is still there even though
GitHub deleted that branch long ago.
---
`git fetch --prune` (or `git remote prune origin`) removes remote-tracking refs whose branch is gone on the
server. Consider `git config --global fetch.prune true` so it happens on every fetch.
Never pipe `git branch --merged` straight into `xargs git branch -d` without excluding `main` and `release/*`.
