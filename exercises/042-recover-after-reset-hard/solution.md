# Solution

```bash
git reflog
# 7c8d9e0 HEAD@{0}: commit: Fix typo in reviews header
# 2b3c4d5 HEAD@{1}: reset: moving to HEAD~2
# 9f0a1b2 HEAD@{2}: commit: Add review moderation queue      <- tip before the accident
# 4e5f6a7 HEAD@{3}: commit: Add star rating widget
# ...

git cherry-pick 9f0a1b2~2..9f0a1b2       # replays "star rating" and "moderation queue"
git log --oneline main..HEAD             # 5 commits, typo fix included
```

Alternative (keeps the original commit hashes of the lost work):

```bash
fix=$(git rev-parse HEAD)                # remember the typo fix
git reset --hard 9f0a1b2                 # back to before the accident
git cherry-pick "$fix"
```

**Why it works:** `reset --hard` only moves a branch pointer (and overwrites your files). The commits it
moved away from still exist; they've just become unreachable from any branch. HEAD's reflog recorded where
HEAD was before the reset, so you can name that commit and either cherry-pick from it or move back to it.
`A~2..A` means "commits reachable from A but not from A~2" — exactly the two lost ones, oldest first.

**Real-world notes**
- Right after a botched reset, `git reset --hard ORIG_HEAD` is the instant undo: `reset`, `merge` and
  `rebase` save the previous tip in `ORIG_HEAD`. Here you'd already committed again, so the reflog is the
  reliable tool (ORIG_HEAD still pointed at the lost tip, but it gets overwritten by the next reset/merge).
- What the reflog **can't** save: uncommitted changes. `reset --hard` overwrites working-tree edits that
  were never committed or stashed, and they're gone (staged ones survive as dangling blobs —
  `git fsck --lost-found`). Commit early, commit often; you can always squash later.
- Habits that prevent this: `git reset --keep` instead of `--hard` (refuses to clobber local changes),
  `git commit --amend` to fix the last commit instead of reset, and `git status`/`git log -3` before any
  destructive command.
- Unreachable reflog entries expire after 30 days by default (`gc.reflogExpireUnreachable`). Recover soon.
