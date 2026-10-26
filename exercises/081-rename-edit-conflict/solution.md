# Solution

```bash
cd repo
git merge main
# CONFLICT (modify/delete): src/price.js deleted in main and modified in HEAD.
git merge --abort

git diff -M --name-status    feature/sale-prices~2 main   # D src/price.js  +  A src/utils/money.js
git diff -M40% --name-status feature/sale-prices~2 main   # R044 src/price.js src/utils/money.js

git merge -X find-renames=40% main                        # clean: your edit lands in src/utils/money.js

git grep -n "'./price'"                                   # src/sale-banner.js:2 … the semantic conflict
# fix it to require('./utils/money')
git commit -am "Point sale banner at src/utils/money.js"
git log --follow --oneline src/utils/money.js             # history continues through the rename
```

By hand instead (inside the conflicted merge): copy the `formatSalePrice` block from `src/price.js` to the end of
`src/utils/money.js`, `git rm src/price.js`, fix `sale-banner.js`, `git add -A`, `git commit`.

**Why it works:** Git doesn't record renames. A commit is just a snapshot; when diffing or merging, Git *infers*
renames by pairing deleted and added files whose content is similar enough — **50 % by default**. Lena moved the
file and grew it in the same commit, so the similarity dropped to 44 % and Git saw an unrelated delete + add.
`-X find-renames=40%` (an option of the default `ort` merge strategy) lowers the threshold for this merge;
then Git does a normal three-way merge of base `src/price.js`, your `src/price.js` and Lena's `src/utils/money.js`,
and your appended function lands in the new file.

Git can only merge *text*. Your new `sale-banner.js` requires a path that no longer exists — no conflict is
reported because no two edits overlap. That's a **semantic conflict**; only `git grep`, tests and CI find it.

**Real-world notes**
- **Move in one commit, edit in the next.** A pure move is a 100 % rename that Git always detects, and
  `git log --follow`, `git blame` and everybody's merges keep working. Ask for this in code review.
- `merge.renames` (defaults to `diff.renames`, which is `true`) only switches detection on/off — the threshold
  comes from `-X find-renames=<n>`. `merge.renameLimit` / `diff.renameLimit` cap how many files are compared;
  big refactors can exceed it and Git prints a warning — raise the limit then.
- Rebasing instead of merging hits the same problem: `git rebase -X find-renames=40% main`.
- Big directory moves are a team event: announce them, merge them quickly, and ask everyone to land or rebase
  in-flight work right after. `git log --diff-filter=R --summary` shows recent renames when something goes missing.
- A failing `require` would have been caught by CI on the PR — another reason `main` should require green checks.
