`git reset` always moves your branch pointer. The mode decides how far the change spreads:
`--soft` = pointer only, `--mixed` (the default) = pointer + index, `--hard` = pointer + index + working tree.
Start with `git status` and `git log --oneline main..HEAD`.
---
Unstaging is a *mixed* reset of a path: `git reset -- notes.txt` (modern spelling: `git restore --staged notes.txt`).
Do this **first**, otherwise the next commit will include your notes.
---
`git reset --soft HEAD~3` moves the branch back to `main` but leaves the index exactly as it was at your last
commit — i.e. all three commits' changes, staged and ready. One `git commit -m "Add free shipping threshold"`
then makes them a single commit.
---
Discard the experiment with `git restore src/price.js` (old spelling: `git checkout -- src/price.js`).
For the question: a hard reset makes the index *and* working tree match the target commit — a file that is
staged but not in that commit gets removed from disk. `echo hard > ../ANSWER`.
