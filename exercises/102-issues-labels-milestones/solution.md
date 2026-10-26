# Solution

```bash
cd "$(./lg where)"; git switch main; git pull

gh label create "priority:high" --color B60205 --description "Fix before anything else"
gh label create "area:checkout" --color 1D76DB --description "Cart, payment, shipping"
gh api repos/{owner}/{repo}/milestones -f title=v1.1 -f description="Checkout polish"

gh issue create --title "Cart total is NaN when an item has no qty" \
  --body "Steps: add an item without qty -> total shows NaN. Expected: qty defaults to 1." \
  --label bug --label "priority:high" --label "area:checkout" --assignee @me --milestone v1.1
gh issue create --title "Add a wishlist" --body "As a shopper I want to save items for later." \
  --label enhancement --assignee @me --milestone v1.1
gh issue create --title "Show free shipping hint in the cart" --body "Show how much is missing for free shipping." \
  --label enhancement --label "area:checkout" --assignee @me --milestone v1.1
gh issue list --milestone v1.1

git switch -c fix/cart-missing-qty
# src/cart.js:  return cart.items.reduce((sum, i) => sum + i.price * (i.qty ?? 1), 0);
git commit -am "Treat a missing qty as 1 in cart total"
git push -u origin fix/cart-missing-qty
gh pr create --title "Treat a missing qty as 1 in cart total" --body "Fixes #4"   # your bug's number
gh pr merge --squash --delete-branch
gh issue view 4                    # state: CLOSED, closed by the PR
```

**Why it works:** labels, assignees and milestones are issue metadata; `gh issue create` sets them at creation
(the label and milestone must exist first). The milestone REST endpoint isn't wrapped by gh, but `gh api`
authenticates for you and expands `{owner}/{repo}` from the current repo. A closing keyword in a PR that is
**merged into the default branch** closes the referenced issue and records the PR as the reason.

**Real-world notes**
- Agree on a *small* label taxonomy: type (`bug`/`enhancement`/`chore`), priority, area. Prefixes like
  `priority:` / `area:` group nicely. `gh label clone other/repo` copies a team's set to a new repo.
- Assign one owner per issue - "assigned to the team" means assigned to nobody.
- Milestones = "what ships in this release" with a due date and a progress bar; Projects (exercise 114) =
  "what state is it in". PMs use both.
- `Fixes #N` only fires on merge into the default branch. A PR into `develop` won't close the issue until that
  lands on `main` - many teams then close by hand or use a Project automation.
- Reference without closing: `Refs #N` / `Part of #N`. Cross-repo: `Fixes org/other-repo#N`.
- Write bug reports a stranger could reproduce: steps, expected, actual, environment. Issue forms (108) enforce it.
