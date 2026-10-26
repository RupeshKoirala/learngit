Labels: `gh label create "priority:high" --color B60205 --description "Drop everything"`.
Milestones have no gh subcommand, but `gh api` can POST to the REST API; inside a repo `{owner}/{repo}` is
filled in for you.
---
```
gh api repos/{owner}/{repo}/milestones -f title=v1.1 -f description="Checkout polish"
gh issue create --title "Cart total is NaN when an item has no qty" --body "..." \
  --label bug --label "priority:high" --label "area:checkout" --assignee @me --milestone v1.1
```
Forgot something on an existing issue? `gh issue edit N --add-label ... --add-assignee @me --milestone v1.1`.
---
For the NaN bug, in `src/cart.js` use `(i.qty ?? 1)` (or `|| 1`) instead of `i.qty`. Branch, commit, push -u,
then `gh pr create --title "Treat missing qty as 1" --body "Fixes #N"`.
---
`gh pr merge --squash --delete-branch`, then `gh issue view N` shows it closed "as completed" by your PR.
Check the whole milestone with `gh issue list --milestone v1.1 --state all`.
