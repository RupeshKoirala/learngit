# Solution

```bash
git switch feature/review-markdown
git merge main
# Auto-merging package.json                                  <- clean!
# CONFLICT (content): Merge conflict in package-lock.json
# CONFLICT (content): Merge conflict in src/product-page.js
git diff HEAD -- package.json               # optional: main's dayjs line came in cleanly
```

**1. The lockfile — pick a side, then regenerate**

```bash
git checkout --theirs package-lock.json     # main's lock: has dayjs, lacks marked, wrong hash
./tools/lock.sh                             # rebuild from the merged package.json
git diff --stat HEAD -- package-lock.json   # sanity check
git add package-lock.json
```

**2. The real code — by hand**

```js
// Product page
const dayjs = require('dayjs');
const { marked } = require('marked');

function renderReview(review) {
  return '<p>' + marked.parseInline(review.text) + '</p><small>' + dayjs(review.date).format('MMM D, YYYY') + '</small>';
}

module.exports = { renderReview };
```

```bash
git add src/product-page.js
git diff --name-only --diff-filter=U        # nothing left unmerged
./test.sh
git commit                                   # "Merge branch 'main' into feature/review-markdown"
./tools/lock.sh && git status --short       # still clean -> the lock was fresh
```

**Why it works:** a lockfile is *output*, not *source*. Its source of truth is `package.json` (which Git
merged fine because the two new lines weren't adjacent). Hand-merging a lockfile — even picking the "right"
hash — can produce something no tool would ever generate: here, either hash would be wrong, because each one
describes only half the dependencies. Taking one side just gets rid of the markers so the generator can run;
the generator then produces the one correct file. `--ours` = the branch you're on (`HEAD`), `--theirs` = the
branch being merged in. (During a **rebase** the meanings flip — ours is the branch you're rebasing *onto*.)

**Real-world notes**
- The same recipe applies to `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `poetry.lock`,
  `Gemfile.lock`, `go.sum`, `Cargo.lock`, generated GraphQL/OpenAPI clients, snapshots, build manifests,
  minified bundles: take a side, rerun the generator, commit.
- With real npm: `git checkout --theirs package-lock.json && npm install`. Modern npm can even fix a
  conflicted lockfile itself (`npm install` detects the markers), and yarn/pnpm have similar behavior.
- Teams can declare this in `.gitattributes`: `package-lock.json merge=ours` (with a configured `ours`
  driver) or `-diff linguist-generated` so GitHub collapses it in PR diffs. CI should fail if the lockfile is
  stale (`npm ci` does exactly that).
- Review tip for leads: in a PR, scan `package.json` changes carefully (every new dependency is supply-chain
  risk and bundle size) and trust the lockfile only if CI regenerated/verified it.
- Never use `--ours/--theirs` as a shortcut for *source* files — that's how work silently disappears
  (exercise 014).
