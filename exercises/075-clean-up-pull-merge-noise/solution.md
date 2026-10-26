# Solution

```bash
cd repo
git fetch                                       # get Dev's newest commit, don't merge anything
git log --oneline --no-merges origin/main..main # your 4 real commits
git rebase origin/main                          # replay them on the tip, merges dropped
git log --oneline --graph -6                    # a straight line
git diff ORIG_HEAD HEAD --stat                  # only Dev's newest change differs from before
git push                                        # a fast-forward: no --force needed
git config pull.rebase true
```

**Why it works:** `git pull` = `git fetch` + `git merge origin/main`. When both sides have new commits, that
merge can't fast-forward and creates a merge commit — three pulls, three bubbles. `git rebase origin/main` takes
the commits reachable from `main` but not from `origin/main`, **skips merge commits**, and re-applies the rest
one by one on top of `origin/main`. The teammates' commits that came in through your merges are already part of
`origin/main`, so they aren't duplicated. Because your local `main` was never pushed, rewriting it hurts no one,
and the result is a fast-forward of `origin/main`, so a plain `git push` works.

**Real-world notes**
- Set it once and forget it: `git config --global pull.rebase true` (or `pull.ff only` to make Git refuse
  anything but fast-forwards and decide yourself). Add `rebase.autoStash true` so a dirty tree doesn't block a pull.
- Merge commits aren't bad — merging a *feature branch* records a real event. "Merge branch 'main' of origin"
  inside `main` records only that you pulled; that's noise and it breaks `git bisect` / `git log --first-parent`.
- If one of those merges contained a **conflict resolution**, a plain rebase will ask you to resolve the same
  conflict again on the corresponding commit (`git rerere` can remember resolutions). Check
  `git log --merges -p --cc` before rebasing to see if any merge carried real work.
- Better still: don't commit on `main` at all. Work on a feature branch and open a PR; `main` then only moves via
  reviewed merges or fast-forwards.
- Already pushed the bubbles? Then they're shared history — leave them (rewriting shared `main` costs more than the
  noise). Fix the habit instead.
