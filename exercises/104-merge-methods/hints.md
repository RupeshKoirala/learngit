The branches are already pushed. From the lab: `gh pr create --head demo/merge-commit --base main --fill`
(same for the other two). `gh pr list` shows the numbers.
---
`gh pr merge <N> --merge`, `gh pr merge <N> --squash`, `gh pr merge <N> --rebase` (add `--delete-branch` if you like).
Then `git switch main && git pull` and `git log --graph --oneline -12`.
---
- merge commit: both of Dev's commits + a "Merge pull request #N" commit with 2 parents
- squash: Lena's 2 commits become 1 new commit "title (#N)"; "fix typo" is gone
- rebase: Maya's 2 commits are re-created on top of main (new hashes), no merge commit
---
```
gh repo edit --enable-merge-commit=false --enable-squash-merge --delete-branch-on-merge
gh repo view --json mergeCommitAllowed,squashMergeAllowed,rebaseMergeAllowed,deleteBranchOnMerge
```
