`git rebase -i main`, and change `pick` to `edit` (`e`) for the commit you want to split. Git replays up to
and including that commit, then **stops** and hands control back to you.
---
While stopped, you're sitting on the commit to split. `git reset HEAD^` moves the branch back one commit but
keeps all its changes in your working tree (unstaged). Now `git status` shows `src/price.js` modified and
`src/rating.js` untracked — nothing is lost.
---
Commit the pieces in the order you want them:

```
git add src/price.js
git commit -m "Fix price rounding for fractional cents"
git add src/rating.js
git commit -m "Add star rating widget"
```
---
Then `git rebase --continue` replays the last commit on top. Check with `git log --stat --oneline main..`.
If the changes were mixed *within one file*, you'd use `git add -p` to pick hunks instead of whole files.
