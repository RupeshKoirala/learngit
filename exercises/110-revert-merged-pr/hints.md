`gh pr create --head feature/express-checkout --base main --fill`, `gh pr merge <N> --squash --delete-branch`.
Then open it in the browser (`gh pr view <N> --web`): at the bottom of a merged PR there's a **Revert** button.
(Some recent gh versions also have `gh pr revert <N>` - check `gh pr --help`.)
---
Terminal route for the revert: `git switch main && git pull`, `git switch -c revert-express`,
`git revert <sha of the squash commit>` (for a merge-commit merge: `git revert -m 1 <merge sha>`), push,
`gh pr create --fill`, merge.
---
Re-land: `git switch main && git pull && git switch -c feature/express-checkout-v2`, then
`git revert <sha of the revert commit>` - the feature is back, unchanged. Now add the fix on top:

```js
function validateAddress(address) {
  if (!address || !address.street) throw new Error('A delivery address is required');
  return address;
}
```
and use `address: validateAddress(customer.address)`.
---
Commit, push, `gh pr create --title "Re-land express checkout with address validation" --body "..."`, merge.
`gh pr list --state merged --limit 5` should show: re-land, Revert "...", Add express checkout.
