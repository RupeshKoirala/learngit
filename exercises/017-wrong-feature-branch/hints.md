Two separate jobs: *copy* the 2 commits onto `feature/wishlist`, then *remove* them from
`feature/search-filters`. Do the copy first, so nothing is ever only in one place. `git log --oneline -4`
shows the hashes you need.
---
`git cherry-pick` replays commits onto the branch you're on. A range works: `X..Y` means "commits reachable
from Y but not from X". So, from `feature/wishlist`:
`git cherry-pick <hash of Add brand filter>..feature/search-filters`
(or simply `feature/search-filters~2..feature/search-filters`).
---
Then make the search branch forget those two commits: switch to it and `git reset --hard HEAD~2`.
`--hard` is fine here because the working tree is clean and the commits now live on `feature/wishlist`.
(Or, without switching: `git branch -f feature/search-filters feature/search-filters~2` from another branch.)
---
Check: `git log --oneline --graph --all`. If a cherry-pick stops with a conflict, `git cherry-pick --abort`.
The original commits stay findable in `git reflog` for weeks if you need to start over.
