# Solution

```bash
git switch main && git pull
git log --oneline main..origin/feature/gift-cards
# 5e6f7a8 Reject redemptions above the card balance      <- the ONLY "unmerged" commit!

git log --oneline --grep='^Revert "Merge' -1
# 4d5e6f7 Revert "Merge branch 'feature/gift-cards'"
git revert 4d5e6f7                         # message: Revert "Revert "Merge branch ...""
git merge origin/feature/gift-cards        # brings in the fix only
git diff origin/feature/gift-cards HEAD -- src/giftcard.js src/cart.js   # empty
./test.sh
git push origin main
```

(Merging first and reverting the revert second also works, but the merge then hits a modify/delete conflict
on `src/giftcard.js` that you'd have to resolve by hand — doing the revert first avoids it.)

**Why it works:** Git merges by looking at history, not at file contents. After the first merge, Lena's two
original commits are ancestors of `main`; the revert commit removed their **changes** but left them in the
**history**. So when you merge the branch again, the merge base is her second commit and Git only considers
what came *after* it — the fix. Lena's original code stays reverted (and here the fix even conflicts, because
it edits a file the revert deleted).

Reverting the revert is the documented way out (see `git help revert` and Linus's "revert-a-faulty-merge"
howto in Git's docs): it re-applies exactly what the revert removed. Then the merge contributes only the fix,
and `main` ends up with the complete, corrected feature — without rewriting anything that's been shared.

**Real-world notes**
- Explain it to Jo in one sentence: *"A revert undoes the changes, not the merge; Git still remembers the
  branch as merged."* This trips up experienced devs regularly — expect to explain it in incident retros.
- On GitHub: click **Revert** on the *revert* PR to get a "revert the revert" PR, then merge Lena's fix PR.
  Alternatively Lena can rebase her branch onto `main` *with new commits* (`git rebase --no-ff` or
  cherry-picks) so the old ones aren't seen as merged — but that rewrites her branch; coordinate first.
- Leave a breadcrumb in the revert-the-revert message: `Re-land gift cards; fix in #482`.
- If your team squash-merges PRs, this trap mostly disappears: re-landing is just another squash-merge.
  That's one real argument in the merge-vs-squash debate.
