`reset --hard` moved your branch, but the commits it moved *away from* aren't deleted — they're just not on
any branch. Your HEAD reflog remembers them: `git reflog` (or `git log -g --oneline`).
---
Look for the entry `reset: moving to HEAD~2`. The entry right below it (older) is where you were before the
reset: `commit: Add review moderation queue`. That hash is the tip of your lost work.
---
Two ways back:
- **Replay the lost commits onto your current branch:**
  `git cherry-pick <lost-tip>~2..<lost-tip>` (the range = the two commits after "Add review form").
- **Or go back and replay the fix on top:** `git reset --hard <lost-tip>` then `git cherry-pick <fix-hash>`
  (note the fix's hash first!).
---
```bash
git reflog                                   # find e.g. HEAD@{2}: commit: Add review moderation queue
git cherry-pick 'HEAD@{2}~2..HEAD@{2}'      # quote in zsh; or paste the hashes
git log --oneline main..HEAD                 # 5 commits
```
