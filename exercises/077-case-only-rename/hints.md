Look at what Git has, not what your file browser shows: `git ls-files`. Compare `git config core.ignorecase`
(true on most Macs/Windows, false on Linux).
---
Let Git do the rename so the index changes: `git mv readme.md README.md`. If Git complains that the destination
exists (older Git on a case-insensitive disk), add `-f`.
---
The bullet-proof way that works on every OS is two steps through a temporary name:
`git mv src/Utils.js src/utils.tmp && git mv src/utils.tmp src/utils.js`
---
Then fix `src/cart.js` (`require('./utils')`), check `git grep -n "Utils'"` is empty, commit, and verify with
`git diff -M --name-status HEAD~1` (look for `R100`).
