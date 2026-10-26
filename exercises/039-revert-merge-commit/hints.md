Look at the graph: `git log --graph --oneline`. Try `git revert <merge-hash>` — Git refuses with
"is a merge but no -m option was given". Why? A merge has **two** parents, so "undo this commit" is
ambiguous: undo it relative to which side?
---
`-m <n>` picks the **mainline** parent — the side you want to go *back to*. Parent 1 is the branch you were
on when merging (main); parent 2 is the branch that was merged in (feature/gift-cards). Check with
`git show --format='%P' -s <merge-hash>` or `git log -1 <merge-hash>^1`.
---
```bash
git revert -m 1 <merge-hash>
./test.sh
git push origin main
```
---
Sanity check before pushing: `git diff <merge-hash>^1 HEAD -- src` should print nothing (src is back to how
main looked right before the merge), while `git log -1 -p` shows giftcard.js being deleted.
