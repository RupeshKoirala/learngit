`git fetch --prune` (or `git remote prune origin`) deletes `origin/*` refs whose branch no longer exists on the
server. Afterwards `git branch -vv` shows `[origin/feature/gift-cards: gone]` on your local branch;
`git branch -d feature/gift-cards` deletes it (it's merged, so `-d` is happy).
---
Deleting a branch on the server is a push of "nothing" to it: `git push origin --delete spike/old-checkout`
(old syntax: `git push origin :spike/old-checkout`).
---
Rename in this order so nothing ever points at a missing branch:
`git branch -m master main` → `git push -u origin main` → switch the server's HEAD to main (command in the task)
→ `git push origin --delete master`.
---
Finally fix your clone's idea of the remote: `git fetch --prune` (drops `origin/master`) and
`git remote set-head origin --auto` (makes `origin/HEAD` -> `origin/main`). Check with `git branch -a -vv`.
