# Solution

```bash
# 1. publish the rebase
git push                              # rejected: non-fast-forward
git push --force-with-lease           # ok: origin still had what you expected

# 2.
./lg event                            # Maya pushes "Escape HTML in order notes" to your branch

# 3. rewrite again, without fetching
git commit --amend -m "Add order note length limit"
git push --force-with-lease           # ! [rejected] feature/order-notes -> feature/order-notes (stale info)

# 4. look, integrate, push
git fetch
git log --oneline HEAD..origin/feature/order-notes   # Maya's commit + your old "lenght" commit
git cherry-pick origin/feature/order-notes            # take only Maya's commit
git log --oneline origin/main..HEAD                    # 4 commits, typo fixed
git push --force-with-lease                            # ok: you've seen and kept everything on origin
```

**Why it works:** `--force-with-lease` is a compare-and-swap. Without arguments it says: "replace the remote
branch, **but only if** it still points where my `origin/feature/order-notes` points". In step 1 that was true
(only you had pushed). In step 3 it was false — Maya pushed after your last fetch — so the server refused
("stale info") instead of destroying her commit. After `git fetch` your remote-tracking ref matches the server
again, and you deliberately built a branch that contains her change, so the final lease push is safe.

Why not `git pull --rebase` in step 4? Git would replay your local commits that aren't on the remote; your amended
commit has the same *patch* as the old "lenght" commit already there, so Git skips it as already applied and you
end up with the typo back. Pulling in a *merge* would bring the old commit back too. When the other side has
your old commits, cherry-pick **their** new commits onto **your** rewritten branch.

**Real-world notes**
- Alias it and forget `--force` exists: `git config --global alias.pushf "push --force-with-lease --force-if-includes"`.
- The lease is defeated by background fetches (VS Code, JetBrains, `git fetch` in a cron): your
  `origin/<branch>` silently moves to include the other person's commit, so the lease "matches" and you overwrite
  it anyway. `--force-if-includes` (Git 2.30+) adds a check that the remote tip is actually in your branch's reflog —
  i.e. that you integrated it, not merely fetched it.
- Even safer lease: name the exact commit you expect: `git push --force-with-lease=feature/order-notes:<sha>`.
- Team etiquette: say in the PR "rebasing, please don't push for 5 minutes", or ask reviewers to leave
  *suggestions* instead of pushing to someone else's branch. Rebase-and-force-push is fine on **your** PR branch;
  on shared branches (`main`, `release/*`) protect them so force-push is impossible.
- GitHub keeps review comments attached to commits that disappeared after a force-push only loosely; reviewers
  appreciate "force-pushed: rebased on main, no code changes" or a link to the `compare` view.
