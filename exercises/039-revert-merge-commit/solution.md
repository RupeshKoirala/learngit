# Solution

```bash
git pull
git log --graph --oneline -8
git log --merges --oneline -1 --grep=gift-cards      # 7b8c9d0 Merge branch 'feature/gift-cards'
git show -s --format='%P' 7b8c9d0                    # <parent1 = main before> <parent2 = feature tip>
git revert -m 1 7b8c9d0                              # keep the default message
git diff 7b8c9d0^1 HEAD -- src                       # empty: src is back to pre-merge main
./test.sh
git push origin main
```

**Why it works:** a normal commit has one parent, so "revert it" means "apply the inverse of the diff to its
parent". A merge has two parents and two different diffs. `-m 1` says: *parent 1 (main) is the mainline;
undo the diff between parent 1 and the merge* — that diff is exactly what the feature branch brought in. Dev's
"Add shipping cost rules" was already on parent 1, so it's not part of that diff and survives. With `-m 2`
you'd instead undo **main's** work since the branch forked — the opposite of what you want.

**Real-world notes**
- Reverting the merge removes the *changes*, not the *history*: Lena's two commits are still ancestors of
  `main`. That's why simply merging her branch again later will **not** bring them back — Git thinks they're
  already merged. You have to "revert the revert" first. That's exercise 040; tell Lena now so she doesn't
  get surprised.
- On GitHub, the **Revert** button on a merged PR does exactly `git revert -m 1` on a new branch and opens
  a PR for it.
- When the merge was a squash-merge or rebase-merge, there's no merge commit: revert the single squashed
  commit, or each rebased commit (`git revert --no-commit A^..B`, then one commit).
- Feature flags make this whole dance unnecessary: turn the feature off in config, fix forward. Mature teams
  ship risky features dark.
