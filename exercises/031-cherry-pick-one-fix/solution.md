# Solution

```bash
git switch main
git log --oneline main..feature/gift-cards     # Dev's 4 commits that main doesn't have
git show feature/gift-cards~2 --stat           # confirm: only src/price.js
git cherry-pick feature/gift-cards~2           # or the hash you saw
./test.sh                                      # tests passed
git log --oneline -3
```

**Why it works:** a commit stores a snapshot, but `cherry-pick` looks at the *diff* between that commit and
its parent, then applies that diff on top of `HEAD` and commits it — reusing the original message and
author. Because the parent is different, the result is a **new commit with a new hash**. Git can still tell
the two are "the same change": `git patch-id` (and `git cherry`, `git log --cherry-pick`) compare the diffs,
not the hashes. That's how the checker verified your commit.

Merging the branch would have dragged all four commits into `main`, test card included. Cherry-pick is the
scalpel.

**Real-world notes**
- **Cherry-pick is a tool for exceptions, not a workflow.** Every pick creates a duplicate commit. When Dev
  later merges his branch, Git usually handles the duplicate fine (identical change → no conflict), but if
  he edits that code again first, you can get confusing conflicts. The better long-term move: ask Dev to
  open a tiny separate PR for the fix (`git switch -c fix/negative-prices main && git cherry-pick …`) and
  then rebase his feature branch on `main` — the rebase will notice the fix is already upstream and drop his copy.
- On a shared repo you wouldn't commit straight to `main`; you'd cherry-pick onto a short branch and open a
  PR. Same command, safer path.
- Add `-x` (`git cherry-pick -x <hash>`) to append `(cherry picked from commit …)` to the message. Teams use
  it for backports so anyone can trace the copy back to the original (exercise 034).
- Cherry-pick keeps the **author** (Dev) but you become the **committer**. `git log --format='%an / %cn'`
  shows both — credit stays where it belongs.
