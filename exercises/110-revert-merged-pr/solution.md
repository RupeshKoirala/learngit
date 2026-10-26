# Solution

```bash
cd "$(./lg where)"
gh pr create --head feature/express-checkout --base main --fill
gh pr merge <N> --squash --delete-branch

# incident! revert via the web: gh pr view <N> --web -> "Revert" -> Create pull request -> merge
# ...or in the terminal:
git switch main && git pull
git switch -c revert-express-checkout
git revert --no-edit <squash-sha>          # merge-commit merges: git revert -m 1 <merge-sha>
git push -u origin HEAD
gh pr create --title "Revert \"Add express checkout\"" --body "Reverts #<N>: guests get address undefined."
gh pr merge --squash --delete-branch

# re-land with a fix
git switch main && git pull
git switch -c feature/express-checkout-v2
git revert --no-edit <revert-sha>          # "revert the revert": the feature is back
# edit src/express.js:
#   function validateAddress(address) {
#     if (!address || !address.street) throw new Error('A delivery address is required');
#     return address;
#   }
#   ... address: validateAddress(customer.address)
git commit -am "Require a delivery address for express checkout"
git push -u origin HEAD
gh pr create --title "Re-land express checkout with address validation" --body "Re-applies #<N>, fixes the guest bug. Refs #<revert>"
gh pr merge --squash --delete-branch
```

**Why it works:** `git revert` adds a commit with the inverse diff - nothing is rewritten, so it's safe on a
protected, shared `main` and passes through PR + CI like any change. The revert is just a commit too, so
reverting *it* restores the original change exactly; your fix goes on top as a normal reviewed commit.

**Real-world notes**
- **Why not just re-merge the old branch?** With merge commits, the original commits are already in `main`'s
  history - Git considers them merged and brings back *nothing*. You must revert the revert (or cherry-pick).
  With squash merges you could re-apply the branch, but "revert the revert + fix" is uniform and reviewable.
- Squash merges make reverts trivial (one commit); a merge commit needs `-m 1` (keep main's side).
- Revert first, even if the fix "is just one line" - a calm fix with tests beats a 2 a.m. hotfix that
  breaks something else. Feature flags avoid many reverts entirely (turn it off without a deploy).
- Communicate: post in the incident channel, link the revert PR, write the re-land PR description with root
  cause + test that would have caught it. Then a short blameless postmortem.
- Reverting a *database migration* or a published API is harder - design changes to be reversible.
