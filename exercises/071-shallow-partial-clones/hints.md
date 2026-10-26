`git rev-parse --is-shallow-repository` prints `true`. In `git blame`, a `^` before the hash marks the **boundary**
commit: Git can't look further back, so it blames everything older on it. Don't trust that answer.
---
`git fetch --deepen=5` adds 5 more commits of history; `git log --oneline | wc -l` grows. `git fetch --unshallow`
fetches everything that's missing and turns it into a normal clone.
---
`git blame -L '/FREE_SHIPPING_THRESHOLD/,+1' -e src/shipping.js` shows the author's email for just that line
(`-e`). Or: `git log -S FREE_SHIPPING_THRESHOLD --reverse --format='%ae %s'` — the first commit that added it.
---
From the sandbox folder: `git clone --filter=blob:none "file://$PWD/remotes/origin.git" partial`.
Check: `git -C partial config remote.origin.partialclonefilter` → `blob:none`.
