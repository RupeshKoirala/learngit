`gh pr create --head hotfix/round-totals --base main --fill` then `gh pr merge <N> --squash --delete-branch`.
Then `gh pr create --head feature/sale-banner --base main --fill` and `gh pr view <M>` - "mergeable: CONFLICTING".
---
```
git fetch origin
git switch feature/sale-banner
git rebase origin/main          # or: git merge origin/main
```
`git status` shows `CHANGELOG.md` as "both modified/added".
---
Edit `CHANGELOG.md`: delete the `<<<<<<<`, `=======`, `>>>>>>>` lines and keep both entries, e.g.

```
## Unreleased
- Fix: totals are rounded to whole cents
- New: sale banner on the home page
```
`git add CHANGELOG.md`, then `git rebase --continue` (or `git commit` for a merge).
---
After a rebase: `git push --force-with-lease`. After a merge: plain `git push`.
Then `gh pr view <M> --json mergeable` -> MERGEABLE (may say UNKNOWN for a few seconds), and `gh pr merge <M> --squash`.
