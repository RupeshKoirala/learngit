Find the fix: `git log --oneline --grep=SEC-112 main`. Then backport to the newest line first — it's
usually the easiest: `git switch release/1.4` and `git cherry-pick -x <hash>`.
---
`-x` appends `(cherry picked from commit <full-hash>)` to the message — even when the pick conflicts and you
finish with `--continue`. Check it with `git log -1` before tagging. Tag with
`git tag v1.4.1` (or `git tag -a v1.4.1 -m "1.4.1: SEC-112"`).
---
On `release/1.3` the pick conflicts in `src/search.js`: the fix's version uses `product.name`, but 1.3 still
calls it `product.title`. Keep the `require('./html')` line and write the escaped *1.3* field:
```js
  return '<li class="result">' + escapeHtml(product.title) + '</li>';
```
Then `git add src/search.js` and `git cherry-pick --continue`.
---
Full sequence:
```bash
fix=$(git log --format=%H --grep=SEC-112 main)
git switch release/1.4 && git cherry-pick -x $fix && git tag v1.4.1
git switch release/1.3 && git cherry-pick -x $fix
# resolve src/search.js, then:
git add src/search.js && git cherry-pick --continue && git tag v1.3.3
```
