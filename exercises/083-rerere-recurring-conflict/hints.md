rerere is off by default. `git config rerere.enabled true` turns it on for this repo (add `--global` in real
life). From then on Git records the conflict "shape" and your resolution under `.git/rr-cache/`.
---
Trial merge: `git merge main`. Fix `src/price.js` (paste the agreed code), then `git add src/price.js` and
`git commit --no-edit`. Look for the line *Recorded resolution for 'src/price.js'*. Peek with
`ls .git/rr-cache`.
---
Throw the merge away: `git reset --hard HEAD~1` (HEAD~1 is your branch tip before the merge; `ORIG_HEAD` works
too right after the merge). Check with `./lg graph` that the merge is gone.
---
Now `git rebase main`. When it stops, Git says *Resolved 'src/price.js' using previous resolution*. The file is
already fixed but not yet marked resolved: `git diff` to double-check, `git add src/price.js`,
`git rebase --continue`. (Set `rerere.autoUpdate true` and even the `git add` happens automatically.)
