Compare the two views: `git log --graph --oneline origin/main` vs `git log --first-parent --oneline origin/main`.
In the first-parent view, one PR merge disappears and a "Merge branch 'main' of github.com:…" commit plus a
plain commit appear instead. That "Merge branch 'main' of …" commit is the suspect.
---
Confirm it with parents: `git log --merges --format='%h %p  %s' origin/main`. For a PR merge, the first parent
(`<hash>^1`) is the previous mainline commit. For the foxtrot, `^1` is Jo's typo fix and `^2` is the real
mainline (`git log --oneline -1 <hash>^2` shows "Merge pull request #51"). Write the hash: `echo <hash> > ../ANSWER`.
---
Your local `main` has a merge `origin/main` doesn't. Since it isn't pushed, rewrite it:
`git rebase origin/main` (a rebase drops the merge and replays just your commit on top). Alternatively
`git reset --hard origin/main && git cherry-pick <your-commit>`. Check: `git log --oneline origin/main..main`
shows exactly one commit, then `git push`.
---
`git config pull.rebase true` (in this repo, no `--global`) makes `git pull` rebase your local commits instead
of merging. `git config pull.ff only` is stricter: `pull` refuses to do anything but fast-forward.
