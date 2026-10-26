# Solution

```bash
git reflog
# a1a1a1a HEAD@{0}: checkout: moving from chore/bump-deps to main
# b2b2b2b HEAD@{1}: commit: Document Node 20 requirement
# c3c3c3c HEAD@{2}: checkout: moving from main to chore/bump-deps
# c3c3c3c HEAD@{3}: checkout: moving from 9f9f9f9 to main
# 9f9f9f9 HEAD@{4}: commit: Fix coupon expiry off-by-one          <- this one
# 8e8e8e8 HEAD@{5}: commit: Add failing test for coupon expiry
# d4d4d4d HEAD@{6}: checkout: moving from main to v1.2
# ...
# 7c7c7c7 HEAD@{n}: commit: debug: log every cart change           <- not this one

git show --stat 9f9f9f9               # confirm it's the fix
git branch hotfix/1.2.1 9f9f9f9       # give it a name. Rescued.
git log --oneline v1.2..hotfix/1.2.1
# 9f9f9f9 Fix coupon expiry off-by-one
# 8e8e8e8 Add failing test for coupon expiry
```

**Why it works:** "detached HEAD" just means `HEAD` points straight at a commit instead of at a branch name.
You can commit there normally — but no branch moves along with you, so when you switch away, nothing refers to
those commits any more. They still exist in the object database, and the **reflog** (a local, per-repo log of
every position `HEAD` and each branch has had) still remembers their hashes. Creating a branch at the tip makes
them reachable again; parents come along automatically. Unreachable commits are only deleted by garbage
collection, and by default not before the reflog entry expires (30 days for unreachable, 90 for reachable).

**Real-world notes**
- When you check out a tag to investigate, start a branch immediately if there's any chance you'll commit:
  `git switch -c hotfix/1.2.1 v1.2`. Detached HEAD is for *looking*, branches are for *working*.
- If you're still on the detached HEAD and realise it, it's even easier: `git switch -c <name>` right there.
- The reflog is **local**: it isn't pushed or cloned. Work that only ever existed on a laptop that died is gone —
  push your branches (even WIP ones) often.
- Last resort when the reflog is gone too (e.g. a fresh clone of a repo with dangling objects):
  `git fsck --lost-found` lists dangling commits.
- Next step in real life: open a PR from `hotfix/1.2.1` into `release/1.2` (or tag `v1.2.1` from it), then
  back-merge or cherry-pick the fix into `main` — the scenario from exercise 014.
