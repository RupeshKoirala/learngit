```
git switch main && git pull && git switch -c stack/1-tax-calc
# add src/tax.js, commit
git push -u origin HEAD
gh pr create --draft --base main --fill
```
---
```
git switch -c stack/2-tax-display          # from stack/1-tax-calc
# add src/price-with-tax.js using require('./tax'), commit
git push -u origin HEAD
gh pr create --base stack/1-tax-calc --fill
```
Look at PR 2's "Files changed": only *your* B changes, because the base is PR 1's branch.
---
`gh pr ready <PR1>` then `gh pr merge <PR1> --squash --delete-branch`.
Now `gh pr view <PR2>`: base is `main` (auto-retargeted) or still the deleted branch - then `gh pr edit <PR2> --base main`.
PR 2 now lists PR 1's original commit too.
---
Replay only B onto the new main. Note the old base first (`git rev-parse stack/1-tax-calc` locally still has it):

```
git fetch origin
git switch stack/2-tax-display
git rebase --onto origin/main stack/1-tax-calc     # "everything after old stack/1, onto main"
git push --force-with-lease
```
(`git rebase -i origin/main` and dropping the A line works too.)
