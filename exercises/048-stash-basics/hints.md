Plain `git stash` only saves **tracked** changes; untracked files stay behind in your working tree.
`-u` (`--include-untracked`) takes them too, and `-m` gives the stash a name you'll recognise later:
`git stash push -u -m "search: half-done ranking"`.
---
After pushing a new stash, every older stash moves down one: the old `stash@{0}` is now `stash@{1}`.
Always re-run `git stash list` before using an index. `git stash show stash@{n}` lists the files a stash
touches; add `-p` to see the full diff.
---
```bash
git stash show -p stash@{2}         # the old WIP one — console.log in ...
echo <that-path> > ../ANSWER
git stash drop stash@{2}
git stash list                      # check the numbers again!
git stash apply stash@{1}           # the fuzzy experiment (apply keeps it in the list)
```
---
Dropped the wrong one? A dropped stash is just an unreferenced commit. `git fsck --unreachable | grep commit`
lists candidates; `git stash store -m "name" <hash>` puts one back. (Same trick saves you after an
accidental `git stash clear`.)
