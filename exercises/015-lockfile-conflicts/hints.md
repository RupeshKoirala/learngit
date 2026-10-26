`git merge main`, then `git status`: `package.json` is already staged (merged cleanly), the lockfile and
`src/product-page.js` are **both modified**. Open the lockfile: the only conflict is the `dependenciesHash`
line — and *neither* hash is right for a project that has both new dependencies.
---
For the lockfile: `git checkout --theirs package-lock.json` (or `--ours`) picks one complete side and drops
the markers. Then `./tools/lock.sh` regenerates it from the merged `package.json`, and `git add package-lock.json`.
During a merge, "ours" is the branch you're on (`HEAD`) and "theirs" is the branch you're merging in.
---
For `src/product-page.js`, keep both `require` lines, and combine the two `return` lines into one:

```js
const dayjs = require('dayjs');
const { marked } = require('marked');

function renderReview(review) {
  return '<p>' + marked.parseInline(review.text) + '</p><small>' + dayjs(review.date).format('MMM D, YYYY') + '</small>';
}
```
---
`git add src/product-page.js`, check nothing is left with `git diff --name-only --diff-filter=U`, then
`git commit`. Verify the lock is fresh: running `./tools/lock.sh` again must leave `git status` clean.
