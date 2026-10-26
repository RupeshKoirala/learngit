# Solution

```bash
git status                                     # M src/search.js, ?? src/search-ui.js
git stash push -u -m "search: half-done ranking"
git status                                     # clean — including the untracked file

git stash list
# stash@{0}: On feature/search: search: half-done ranking
# stash@{1}: On feature/search: experiment: fuzzy matching
# stash@{2}: WIP on feature/search: 1a2b3c4 Add basic product search

git stash show -p stash@{2}                    # + console.log('DEBUG order', order); in src/payment.js
echo src/payment.js > ../ANSWER
git stash drop stash@{2}

git stash apply stash@{1}                      # fuzzy experiment back in the working tree, still listed
git stash list
```

**Why it works:** a stash is a small bundle of commits stored on the special ref `refs/stash` (its reflog
*is* the stash list). `stash@{2}` means "the entry two back in that reflog" — which is why numbers shift
every time you push or drop. With `-u`, Git adds a third parent commit holding the untracked files (you can
see it: `git show stash@{0}^3`). `apply` restores the changes and keeps the entry; `pop` = `apply` + `drop`
(and it only drops if the apply succeeded without conflicts).

**Real-world notes**
- **Name every stash.** `WIP on feature/search: 1a2b3c4 …` tells you nothing two weeks later; the fuzzy
  one you found instantly. Without `-m` you're guessing, with `stash show -p` as your only rescue.
- **Indexes shift, names don't.** Refer to a stash by message instead of number:
  `git stash apply "stash^{/fuzzy}"` (the newest stash whose message matches).
- `-u` skips *ignored* files (`node_modules/`, `.env`); `-a` (`--all`) includes them — rarely what you want.
- A stash is local and invisible to teammates. If the work matters for more than a day, commit it on a
  WIP branch and push it instead (`git switch -c wip/ranking && git commit -am "WIP"`). Stashes are for
  minutes-to-hours interruptions, not storage.
- Dropped the wrong one? `git stash drop` prints the hash (`Dropped stash@{2} (abc123…)`). `git stash
  store -m "name" abc123` brings it back.
