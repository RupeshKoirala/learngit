# Solution

```bash
git pull                                           # make sure you're on the latest main
git log -S "Math.round" --oneline -- src/price.js  # pickaxe: which commit introduced it?
# 3c4d5e6 Show prices as whole dollars
git show 3c4d5e6                                   # confirm it's the culprit
git revert 3c4d5e6                                 # save the default message
./test.sh                                          # tests passed
git push origin main
git log --oneline -4
# 9f8e7d6 Revert "Show prices as whole dollars"
# a1b2c3d Document the deploy schedule
# ...
```

**Why it works:** `git revert` computes the diff the bad commit introduced and applies its inverse as a
**new** commit. Nothing that already exists changes, so `origin/main` simply fast-forwards and every teammate
gets the fix with a normal `git pull`. The commits from Lena and Maya are untouched, because a revert only
undoes the lines that one commit changed.

**Why not `reset` + force-push?** Removing the commit from `main` would give it different history from every
clone on the team. Their next pull would try to merge the "deleted" commit right back in, or worse, someone
force-pushes their old copy over yours. That's why GitHub's branch protection blocks force-pushes to `main` —
and why this sandbox's remote rejects them too.

**Real-world notes**
- Revert first, investigate later. In an incident, the goal is to stop the bleeding with the smallest,
  safest change; Dev can open a proper fix (keep cents, round correctly) in a new PR.
- Keep the generated message — `This reverts commit <sha>.` links the two commits forever, and tools
  (and `git log --grep`) rely on it. Add a line *why* (`Prices shown without cents, see INC-142`).
- On a protected `main` you'd normally push the revert to a branch and open a PR. GitHub has a **Revert**
  button on merged PRs that does exactly that.
- Reverting a commit that later commits depend on can conflict; resolve like any merge, then
  `git revert --continue`. Several bad commits: `git revert --no-commit A B C` then one commit.
- Reverting is "safe for history", not "safe for data": if the bad commit ran a migration, reverting the code
  doesn't undo the database. Think about side effects.
