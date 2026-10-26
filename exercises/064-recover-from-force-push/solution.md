# Solution

```bash
git reflog show release/2.4
# 9d27f13 release/2.4@{0}: reset: moving to origin/release/2.4
# 4be1c0a release/2.4@{1}: commit: Changelog: sales tax          <- your old tip
# ...
git log --oneline HEAD..release/2.4@{1}       # your two commits

git cherry-pick HEAD..release/2.4@{1}         # re-apply them on top of Dev's commits
git log --oneline --graph -5
./test.sh
git push                                      # fast-forward: Dev's work stays

# make it impossible next time (stand-in for GitHub branch protection)
git --git-dir=../remotes/origin.git config receive.denyNonFastForwards true
```

Also fine: `git rebase --onto origin/release/2.4 <Cut-release-commit> release/2.4@{1}` then move the branch, or
`git merge release/2.4@{1}` (keeps your original commits and adds a merge commit) — anything that ends with both
your commits and Dev's on origin, pushed without force.

**Why it works:** commits are never edited, only *un-referenced*. `git reset --hard` moved the branch label;
the reflog (`.git/logs/refs/heads/release/2.4`) still records where it pointed before, and the commits stay in
the object database until garbage collection prunes unreachable objects (by default ≥ 2 weeks after they fall
out of the reflog, which itself keeps 90 days). `HEAD..release/2.4@{1}` is "commits in my old tip that the
current branch doesn't have" — exactly what the force-push erased. Cherry-picking them onto Dev's tip produces a
history that *contains* the current remote tip, so a normal push is accepted.

Also worth knowing: `origin/release/2.4` has a reflog too (`git reflog show origin/release/2.4`), and so does
*every teammate's* clone. Whoever fetched last before the force-push has the lost commits.

**Real-world notes**
- **Read "(forced update)" in fetch output as an alarm.** Before resetting to the remote, ask what you'd lose:
  `git log --oneline origin/release/2.4..release/2.4`. If that's non-empty, don't `reset --hard` — rebase or
  cherry-pick instead.
- Protect shared branches (`main`, `release/*`): GitHub rulesets → "Block force pushes", "Require linear history",
  "Require a pull request". `receive.denyNonFastForwards` is the plain-Git equivalent on a self-hosted server.
- Blameless follow-up as a lead: Dev did what the tool let him do. Fix the system (protection + team alias
  `pushf = push --force-with-lease --force-if-includes`), then share a 3-line "how to recover" note.
- On GitHub the server keeps an activity log; the old tip is often still reachable via the PR timeline,
  the "Activity" view of the branch, or the REST events API — handy when no one's local clone has it.
