# Solution

```bash
git push                         # rejected (fetch first)
git pull --rebase                # fetch Dev's commit, replay your 2 commits on top of it
git log --oneline --graph -5     # yours on top of "Round cents before formatting prices"
./test.sh                        # always re-test after integrating someone else's change
git push                         # now a fast-forward: accepted
```

Equivalent long form: `git fetch` → `git log --oneline main..origin/main` (see what Dev pushed) →
`git rebase origin/main` → `git push`.

**Why it works:** the server accepts a normal push only if the new tip *contains* the old one (a fast-forward).
Dev's commit is on the server but not in your history, so your push would delete it — Git refuses. Rebasing
re-creates your two (unpublished) commits on top of `origin/main`, so your tip now contains Dev's commit and the
push is a plain fast-forward. Rewriting those two commits is safe precisely because nobody else has them yet.

**Real-world notes**
- **Never answer a rejected push with `--force`** on a shared branch. "fetch first" means "someone else's work
  is up there". Forcing deletes it from the remote (exercise 064 is the cleanup after someone did).
- Make it your default: `git config --global pull.rebase true` (plus `rebase.autoStash true` if you often pull
  with uncommitted changes). Plain `git pull` then rebases your local commits.
- If the rebase hits a conflict: fix the file, `git add` it, `git rebase --continue` — or `git rebase --abort`
  to get back exactly where you were.
- On busy branches you'll lose this race repeatedly. That's a smell: move to short-lived feature branches and
  PRs with a merge queue, so the server — not each developer — serializes integration.
- Re-run the tests after the rebase and before the push. "It passed on my machine" was before Dev's change.
