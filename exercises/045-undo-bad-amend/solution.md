# Solution

```bash
git reflog -3
# 5e6f7a8 HEAD@{0}: commit (amend): Add order confirmation email
# 1b2c3d4 HEAD@{1}: commit: Add order confirmation email          <- the original
# 9a8b7c6 HEAD@{2}: checkout: moving from main to feature/order-emails

git show --stat 'HEAD@{1}'           # only src/email.js — good
git reset --soft 'HEAD@{1}'          # branch back to the original, index untouched
git status                           # Changes to be committed: src/price.js
git commit -m "Fix price rounding"
git log --stat --oneline main..HEAD
```

**Why it works:** `--amend` builds a brand-new commit from the current index and the old commit's parent,
then moves the branch to it. The original commit is untouched and still in the reflog as `HEAD@{1}`.
`reset --soft` moves the branch back to it but leaves the index holding the amended snapshot — so
"index minus original commit" is exactly the price fix, staged and ready for its own commit. Bonus: the
first commit is *the very same commit object* as before the accident (same hash), not a look-alike.

**Real-world notes**
- `HEAD@{1}` is only right if you do this immediately. After more commands, read `git reflog` and pick the
  entry *below* `commit (amend)`. `ORIG_HEAD` is **not** set by amend, so don't rely on it here.
- If the amend also changed the message (`--amend -m …`), this still works; you're restoring the old
  commit including its old message.
- Already pushed the amended commit? Then the remote has the combined version. On your own feature branch,
  fix it locally as above and `git push --force-with-lease`. On a shared branch, leave it and make a
  follow-up commit instead.
- Make amend deliberate: many devs alias `git commit --amend --no-edit` to something long-ish (`git oops`)
  instead of relying on shell-history recall of `git commit --amend`.
