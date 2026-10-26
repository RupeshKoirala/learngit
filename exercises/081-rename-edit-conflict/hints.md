Ask Git how similar the files are: `git diff -M --name-status feature/sale-prices~2 main` shows `D` + `A`. Lower the
threshold: `git diff -M40% --name-status …` shows `R044 src/price.js src/utils/money.js`.
---
The merge accepts the same knob. Abort the conflicted merge with `git merge --abort`, then
`git merge -X find-renames=40% main` — now Git pairs the two files and applies your edit to `src/utils/money.js`.
---
Prefer to resolve by hand? In the conflicted merge: copy your `formatSalePrice` block from `src/price.js` into
`src/utils/money.js`, then `git rm src/price.js`, `git add src/utils/money.js`, and commit.
---
A clean merge isn't the end: `git grep -n "'./price'"` finds code that still points at the old path. Fix
`src/sale-banner.js`, then commit (amend the merge with `git commit --amend` or add a follow-up commit).
