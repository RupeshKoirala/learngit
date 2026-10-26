# Solution

```bash
git rebase -i main
```

```
pick 1111111 Add product reviews model
edit 2222222 Add star rating widget + fix price rounding
pick 3333333 Show average rating on product page
```

Git stops at the mixed commit ("Stopped at 2222222… You can amend the commit now").

```bash
git reset HEAD^                      # undo the commit, keep its changes in the working tree
git status                           # price.js modified, rating.js untracked

git add src/price.js
git commit -m "Fix price rounding for fractional cents"
git add src/rating.js
git commit -m "Add star rating widget"

git rebase --continue
git log --stat --oneline main..
git diff ORIG_HEAD HEAD              # empty: same final code
```

**Why it works:** `edit` makes the rebase pause right *after* re-applying that commit. `git reset HEAD^`
(mixed reset) moves the branch back to the commit's parent but leaves the working tree untouched, so you're
looking at the commit's changes as uncommitted work. You then make as many commits as you like from them, and
`--continue` replays the remaining commits on top. Because you committed everything, nothing changes in the
final tree — only the history is sliced differently.

**When the changes are in the same file**, stage by hunk instead of by file: `git add -p src/file.js`
(`y`/`n` per hunk, `s` to split a hunk, `e` to edit it by hand). Run the tests on each piece if you can:
`git stash --keep-index` + `./test.sh` checks exactly what's staged.

**Real-world notes**
- "One logical change per commit" pays off exactly in moments like this: hotfixes via `git cherry-pick`, clean
  `git revert`s, and `git bisect` pointing at a small commit instead of a grab-bag.
- Put the commit that others may need *first* (fixes, refactors, renames), the feature after it. Then the fix
  can also be its own tiny PR that merges today while the feature keeps getting reviewed.
- As a lead, ask for this in review ("can you split the rounding fix into its own commit?") — and make it easy
  by showing people `edit` + `reset HEAD^`; most developers have never seen it.
- Since the branch was rewritten, push with `git push --force-with-lease` if it was already on the remote.
