# Solution

```bash
git log --oneline feature/search-api..feature/search-ui   # exactly my 2 commits
git rebase --onto main feature/search-api feature/search-ui
git log --oneline --graph main~2..feature/search-ui
```

```
* Debounce search box input          <- feature/search-ui
* Add search box component
* Add support email to README        <- main
* Add product search API (#42)
```

Optionally clean up the merged branch: `git branch -D feature/search-api` (`-D` because Git can't tell it's
merged — another squash-merge side effect).

**Why it works:** every rebase is really `rebase --onto <newbase> <upstream> <branch>`: "take the commits in
`upstream..branch` and replay them on `newbase`." Plain `git rebase main` is shorthand for
`--onto main main`, so its range `main..feature/search-ui` includes Dev's three commits — they aren't
*ancestors* of main (the squash created a new, unrelated commit), so Git thinks they still need applying. They
also aren't patch-identical to #42, so Git can't auto-skip them, and you get conflicts against their own
squashed version. With `--onto main feature/search-api` you cut the range at the right place, so only your two
commits move.

**Real-world notes**
- This situation is *extremely* common on teams that squash-merge: "my PR suddenly shows 15 commits / conflicts
  after my teammate's PR merged" — this is the fix. The same applies to rebase-merges (rewritten hashes).
- If Dev's branch is gone (deleted after merge, also on the remote), use the hash of its last commit, or
  `git rebase -i main` and simply `drop` his commits from the todo list — equally valid.
- Stacking work on an unmerged teammate branch is fine, but say so in your PR ("based on #42, review after it
  merges") and, on GitHub, set the PR's base branch to his branch so the diff only shows your commits. When #42
  merges, GitHub retargets your PR to main — then do this `--onto` rebase and force-push with lease.
- `git rebase --onto` is also the tool for "I branched from the wrong branch": `git rebase --onto main
  wrong-base my-branch` transplants your commits.
