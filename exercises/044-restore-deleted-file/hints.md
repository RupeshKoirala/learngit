`git log` can filter commits by *what happened to a file*. `--diff-filter=D` keeps only commits that
**deleted** something. Combine it with a path: `git log --diff-filter=D --oneline -- src/coupons.js`.
(The `--` matters: the file doesn't exist anymore, so Git needs to be told it's a path.)
---
In the deleting commit the file doesn't exist; in its **parent** it does, in its final form. The parent of
commit `X` is written `X^` (or `X~1`). Peek at it: `git show X^:src/coupons.js`.
---
`git restore --source=X^ -- src/coupons.js` copies that version into your working tree (old spelling:
`git checkout X^ -- src/coupons.js`, which also stages it). Then add and commit only that file.
---
```bash
git log --diff-filter=D --format=%h -1 -- src/coupons.js > ../ANSWER
git restore --source="$(cat ../ANSWER)^" -- src/coupons.js
git add src/coupons.js
git commit -m "Restore coupon codes for Black Friday"
```
