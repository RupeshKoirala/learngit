# Solution

**1. Find the pre-rebase tip**

```bash
git reflog
# a1a1a1a HEAD@{0}: reset: moving to HEAD
# a1a1a1a HEAD@{1}: rebase (finish): returning to refs/heads/feature/returns
# a1a1a1a HEAD@{2}: rebase (pick): Charge a restocking fee for opened items
# b2b2b2b HEAD@{3}: rebase (pick): Add returns policy module
# c3c3c3c HEAD@{4}: rebase (start): checkout main
# d4d4d4d HEAD@{5}: checkout: moving from main to feature/returns     <- before the rebase
# ...

git reflog show feature/returns          # shorter: only the branch's own moves
# a1a1a1a feature/returns@{0}: rebase (finish): refs/heads/feature/returns onto ...
# d4d4d4d feature/returns@{1}: commit: Charge a restocking fee for opened items

git log --oneline d4d4d4d                # yes: 3 commits including "Extend the return window to 30 days"
git tag before-rebase d4d4d4d
```

**2. Restore and redo**

```bash
git reset --hard before-rebase           # on feature/returns: branch is back, nothing lost
git rebase main
# CONFLICT (content): Merge conflict in README.md
$EDITOR README.md                        # keep both lines
git add README.md
git rebase --continue
git log --oneline main..                 # 3 commits
```

**Why it works:** a rebase never destroys commits — it creates new ones and moves the branch pointer. The old
commits stay in the object database, and every pointer move is logged in the **reflog** (per branch and for
`HEAD`). `ORIG_HEAD` is a single convenience pointer that rebase/reset/merge set to "where you were before";
any later `reset` (even `reset --hard HEAD`) overwrites it, which is why it showed the bad state. The reflog
holds the full sequence, so `feature/returns@{1}` (or the hash) gets you back. `git reset --hard <commit>`
then moves the branch to it.

And the lesson behind the accident: `git rebase --skip` drops the **entire** commit being replayed, not just the
conflicting hunk. Use it only when the commit is already upstream (exercise 021).

**Real-world notes**
- Before any big rewrite, make a cheap backup: `git tag backup/returns` or `git branch returns-backup`. Delete it
  when you're happy. Seniors do this reflexively.
- Undo right after a rebase: `git reset --hard ORIG_HEAD` — but only if you haven't run another
  reset/merge/rebase since. Otherwise the reflog, always.
- Reflog entries expire (default 90 days for reachable, 30 for unreachable commits), and the reflog is **local**:
  it's not pushed and not on a fresh clone. If you'd force-pushed the bad rebase and lost your laptop, the
  remote's history (or a teammate's clone, or GitHub's PR "force-pushed" event) would be your best bet.
- If the bad rebase was already pushed: restore locally as above, redo, then `git push --force-with-lease`, and
  tell anyone who pulled it.
- Teach this to juniors early: knowing that "Git almost never loses committed work" is what makes people
  confident enough to use rebase at all.
